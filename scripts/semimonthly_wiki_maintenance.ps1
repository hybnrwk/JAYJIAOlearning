[CmdletBinding()]
param(
    [string]$RepoRoot = "",
    [string]$Remote = "origin",
    [string]$Branch = "main",
    [int]$ScheduledHour = 18,
    [int]$ScheduledMinute = 30,
    [int]$CodexAttempts = 3,
    [int]$CodexRetryDelaySeconds = 120,
    [int]$NetworkRetries = 5,
    [int]$NetworkRetryDelaySeconds = 60,
    [int]$MaxSourcePathChars = 260,
    [int64]$MaxSourceBytes = 524288000,
    [int]$MaxSourceFiles = 120,
    [string]$CodexPath = "$env:LOCALAPPDATA\Programs\OpenAI\Codex\bin\codex.exe",
    [switch]$Fallback,
    [switch]$ForceDue,
    [switch]$ValidateOnly,
    [switch]$PreflightOnly,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$env:GIT_TERMINAL_PROMPT = "0"

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
}
$script:RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$script:LogDir = Join-Path $env:LOCALAPPDATA "JAYJIAOlearning"
$script:LogPath = Join-Path $script:LogDir "semimonthly-wiki.log"
$script:StatePath = Join-Path $script:LogDir "semimonthly-wiki-state.json"
$script:WorktreeRoot = Join-Path $script:LogDir "wiki-worktrees"
$script:PromptRoot = Join-Path $script:LogDir "wiki-prompts"
$script:BackupRoot = Join-Path $script:LogDir "wiki-backups"
$script:ActiveWorktree = $null
$script:ApplyContext = $null
$script:CommitCreated = $false
$script:Mutex = $null

function Initialize-LocalPaths {
    New-Item -ItemType Directory -Force -Path $script:LogDir | Out-Null
    New-Item -ItemType Directory -Force -Path $script:WorktreeRoot | Out-Null
    New-Item -ItemType Directory -Force -Path $script:PromptRoot | Out-Null
    New-Item -ItemType Directory -Force -Path $script:BackupRoot | Out-Null
}

function Write-Log {
    param([string]$Message)

    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    try {
        Add-Content -LiteralPath $script:LogPath -Value $line -Encoding UTF8
    } catch {
        # Logging must not make the maintenance run fail.
    }
    Write-Host $line
}

function Invoke-GitRaw {
    param(
        [string]$WorkingDirectory = $script:RepoRoot,
        [Parameter(Mandatory = $true)][string[]]$GitArgs
    )

    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    Push-Location -LiteralPath $WorkingDirectory
    try {
        $output = & git @GitArgs 2>&1
        $code = $LASTEXITCODE
    } finally {
        Pop-Location
        $ErrorActionPreference = $oldPreference
    }

    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($line in $output) {
        if ($null -eq $line) { continue }
        $text = $line.ToString()
        if (-not [string]::IsNullOrWhiteSpace($text)) {
            $lines.Add($text)
        }
    }

    return [PSCustomObject]@{
        ExitCode = $code
        Output = @($lines)
    }
}

function Invoke-Git {
    param(
        [string]$WorkingDirectory = $script:RepoRoot,
        [Parameter(Mandatory = $true)][string[]]$GitArgs
    )

    $result = Invoke-GitRaw -WorkingDirectory $WorkingDirectory -GitArgs $GitArgs
    foreach ($line in $result.Output) {
        Write-Log ("git: {0}" -f $line)
    }
    if ($result.ExitCode -ne 0) {
        throw ("git {0} failed with exit code {1}" -f ($GitArgs -join " "), $result.ExitCode)
    }
    return @($result.Output)
}

function Invoke-GitWithRetry {
    param(
        [string]$WorkingDirectory = $script:RepoRoot,
        [Parameter(Mandatory = $true)][string[]]$GitArgs,
        [int]$Attempts = $NetworkRetries,
        [int]$DelaySeconds = $NetworkRetryDelaySeconds
    )

    if ($Attempts -lt 1) { $Attempts = 1 }
    if ($DelaySeconds -lt 0) { $DelaySeconds = 0 }

    for ($attempt = 1; $attempt -le $Attempts; $attempt++) {
        Write-Log ("git {0} attempt {1}/{2}" -f ($GitArgs -join " "), $attempt, $Attempts)
        $result = Invoke-GitRaw -WorkingDirectory $WorkingDirectory -GitArgs $GitArgs
        foreach ($line in $result.Output) {
            Write-Log ("git: {0}" -f $line)
        }
        if ($result.ExitCode -eq 0) {
            return @($result.Output)
        }
        if ($attempt -lt $Attempts) {
            Write-Log ("git command failed with exit code {0}; retrying in {1}s." -f $result.ExitCode, $DelaySeconds)
            if ($DelaySeconds -gt 0) {
                Start-Sleep -Seconds $DelaySeconds
            }
        }
    }

    throw ("git {0} failed after {1} attempt(s)" -f ($GitArgs -join " "), $Attempts)
}

function Get-GitLines {
    param(
        [string]$WorkingDirectory = $script:RepoRoot,
        [Parameter(Mandatory = $true)][string[]]$GitArgs
    )

    $result = Invoke-GitRaw -WorkingDirectory $WorkingDirectory -GitArgs $GitArgs
    if ($result.ExitCode -ne 0) {
        throw ("git {0} failed with exit code {1}: {2}" -f ($GitArgs -join " "), $result.ExitCode, ($result.Output -join "`n"))
    }
    return @($result.Output | Where-Object { -not $_.StartsWith("warning:") })
}

function Get-SingleGitLine {
    param(
        [string]$WorkingDirectory = $script:RepoRoot,
        [Parameter(Mandatory = $true)][string[]]$GitArgs
    )

    $lines = @(Get-GitLines -WorkingDirectory $WorkingDirectory -GitArgs $GitArgs)
    if ($lines.Count -ne 1) {
        throw ("Expected one line from git {0}, found {1}." -f ($GitArgs -join " "), $lines.Count)
    }
    return $lines[0].Trim()
}

function Normalize-RelativePath {
    param([string]$Path)

    $normalized = ($Path -replace "\\", "/").Trim()
    while ($normalized.StartsWith("./")) {
        $normalized = $normalized.Substring(2)
    }
    return $normalized.TrimStart("/")
}

function Normalize-PathSegments {
    param([string]$Path)

    $parts = New-Object System.Collections.Generic.List[string]
    foreach ($part in (Normalize-RelativePath $Path) -split "/") {
        if ([string]::IsNullOrWhiteSpace($part) -or $part -eq ".") { continue }
        if ($part -eq "..") {
            if ($parts.Count -eq 0) { return $null }
            $parts.RemoveAt($parts.Count - 1)
            continue
        }
        $parts.Add($part)
    }
    return ($parts -join "/")
}

function Get-SafeRepoPath {
    param(
        [string]$Root,
        [string]$RelativePath
    )

    $normalized = Normalize-PathSegments $RelativePath
    if ([string]::IsNullOrWhiteSpace($normalized)) {
        throw "Invalid repository-relative path: $RelativePath"
    }
    $fullRoot = [System.IO.Path]::GetFullPath($Root).TrimEnd("\", "/")
    $fullPath = [System.IO.Path]::GetFullPath((Join-Path $fullRoot ($normalized -replace "/", "\")))
    $prefix = $fullRoot + [System.IO.Path]::DirectorySeparatorChar
    if (-not $fullPath.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Path escapes repository root: $RelativePath"
    }
    return $fullPath
}

function Test-IndexPath {
    param([string]$Path)

    $leaf = [System.IO.Path]::GetFileName((Normalize-RelativePath $Path))
    return $leaf -like "00-*索引.md"
}

function Test-AllowedMaintenancePath {
    param([string]$Path)

    $normalized = Normalize-RelativePath $Path
    if ($normalized.StartsWith("00-Wiki/", [System.StringComparison]::OrdinalIgnoreCase)) {
        return $normalized.EndsWith(".md", [System.StringComparison]::OrdinalIgnoreCase)
    }
    if (($normalized.StartsWith("cs_ds/", [System.StringComparison]::OrdinalIgnoreCase) -or
         $normalized.StartsWith("数统/", [System.StringComparison]::OrdinalIgnoreCase)) -and
        (Test-IndexPath $normalized)) {
        return $true
    }
    return $false
}

function Test-SourcePath {
    param([string]$Path)

    $normalized = Normalize-RelativePath $Path
    $extension = [System.IO.Path]::GetExtension($normalized)
    if ($extension -ine ".md" -and $extension -ine ".pdf") { return $false }
    if ($normalized -ieq "README.md" -or $normalized -ieq "AGENTS.md") { return $false }
    if ($normalized.StartsWith("00-Wiki/", [System.StringComparison]::OrdinalIgnoreCase)) { return $false }
    if ($normalized.StartsWith("scripts/", [System.StringComparison]::OrdinalIgnoreCase)) { return $false }
    if ($extension -ieq ".md" -and (Test-IndexPath $normalized)) { return $false }
    return $true
}

function Get-State {
    $state = @{}
    if (-not (Test-Path -LiteralPath $script:StatePath -PathType Leaf)) {
        return $state
    }

    try {
        $parsed = Get-Content -LiteralPath $script:StatePath -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($property in $parsed.PSObject.Properties) {
            $state[$property.Name] = $property.Value
        }
    } catch {
        Write-Log ("Ignoring unreadable state file: {0}" -f $_.Exception.Message)
    }
    return $state
}

function Save-State {
    param([hashtable]$State)

    if ($DryRun) {
        Write-Log "[dry-run] state not updated."
        return
    }
    $json = $State | ConvertTo-Json -Depth 8
    [System.IO.File]::WriteAllText($script:StatePath, $json, [System.Text.UTF8Encoding]::new($false))
}

function Get-LatestDueSlot {
    param([datetime]$Now = (Get-Date))

    $monthStart = [datetime]::new($Now.Year, $Now.Month, 1, $ScheduledHour, $ScheduledMinute, 0, $Now.Kind)
    $slots = @(
        $monthStart.AddDays(14),
        $monthStart,
        $monthStart.AddMonths(-1).AddDays(14)
    )
    return @($slots | Where-Object { $_ -le $Now } | Sort-Object -Descending)[0]
}

function Test-CommitExists {
    param([string]$Commit)

    if ([string]::IsNullOrWhiteSpace($Commit)) { return $false }
    $result = Invoke-GitRaw -GitArgs @("cat-file", "-e", "$Commit^{commit}")
    return $result.ExitCode -eq 0
}

function Get-HeadCommit {
    param([string]$WorkingDirectory = $script:RepoRoot)
    return Get-SingleGitLine -WorkingDirectory $WorkingDirectory -GitArgs @("rev-parse", "HEAD")
}

function Get-RemoteCommit {
    $reference = "refs/remotes/{0}/{1}" -f $Remote, $Branch
    $result = Invoke-GitRaw -GitArgs @("rev-parse", "--verify", $reference)
    if ($result.ExitCode -ne 0 -or $result.Output.Count -eq 0) {
        throw "Unable to resolve $reference after fetch."
    }
    return $result.Output[0].Trim()
}

function Assert-BranchSynchronized {
    $currentBranch = Get-SingleGitLine -GitArgs @("rev-parse", "--abbrev-ref", "HEAD")
    if ($currentBranch -ne $Branch) {
        throw "Expected branch '$Branch', found '$currentBranch'."
    }

    $reference = "refs/remotes/{0}/{1}" -f $Remote, $Branch
    $counts = (Get-SingleGitLine -GitArgs @("rev-list", "--left-right", "--count", "HEAD...$reference")) -split "\s+"
    if ($counts.Count -ne 2) {
        throw "Unexpected ahead/behind result for HEAD...$reference."
    }
    $ahead = [int]$counts[0]
    $behind = [int]$counts[1]
    if ($ahead -gt 0 -and $behind -gt 0) {
        throw "Local and remote branches have diverged. Automatic merge is disabled."
    }
    if ($behind -gt 0) {
        throw "Local branch is behind $Remote/$Branch by $behind commit(s). Automatic pull is disabled."
    }
    if ($ahead -gt 0) {
        throw "Local branch has $ahead unpushed commit(s) not owned by this task."
    }
}

function Add-SourceCandidate {
    param(
        [System.Collections.Generic.HashSet[string]]$Set,
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) { return }
    $normalized = Normalize-RelativePath $Path
    if (-not (Test-SourcePath $normalized)) { return }
    try {
        $full = Get-SafeRepoPath -Root $script:RepoRoot -RelativePath $normalized
        if (Test-Path -LiteralPath $full -PathType Leaf) {
            [void]$Set.Add($normalized)
        }
    } catch {
        Write-Log ("Skipped unreadable source candidate '{0}': {1}" -f $normalized, $_.Exception.Message)
    }
}

function Get-SourceCandidates {
    param([hashtable]$State)

    $paths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $baseCommit = if ($State.ContainsKey("LastProcessedCommit")) { [string]$State["LastProcessedCommit"] } else { "" }
    if (Test-CommitExists $baseCommit) {
        foreach ($path in Get-GitLines -GitArgs @("-c", "core.quotePath=false", "diff", "--name-only", "--diff-filter=ACMRT", "$baseCommit..HEAD", "--", "*.md", "*.pdf")) {
            Add-SourceCandidate -Set $paths -Path $path
        }
    } else {
        if (-not [string]::IsNullOrWhiteSpace($baseCommit)) {
            Write-Log ("Ignoring invalid LastProcessedCommit: {0}" -f $baseCommit)
        }
        foreach ($path in Get-GitLines -GitArgs @("-c", "core.quotePath=false", "log", "--since=16 days ago", "--name-only", "--pretty=format:", "--", "*.md", "*.pdf")) {
            Add-SourceCandidate -Set $paths -Path $path
        }
    }

    foreach ($args in @(
        @("-c", "core.quotePath=false", "diff", "--name-only", "--diff-filter=ACMRT", "--", "*.md", "*.pdf"),
        @("-c", "core.quotePath=false", "diff", "--cached", "--name-only", "--diff-filter=ACMRT", "--", "*.md", "*.pdf"),
        @("-c", "core.quotePath=false", "ls-files", "--others", "--exclude-standard", "--", "*.md", "*.pdf")
    )) {
        foreach ($path in Get-GitLines -GitArgs $args) {
            Add-SourceCandidate -Set $paths -Path $path
        }
    }

    if ($State.ContainsKey("DeferredSources")) {
        foreach ($path in @($State["DeferredSources"])) {
            Add-SourceCandidate -Set $paths -Path ([string]$path)
        }
    }

    return @($paths | Sort-Object {
        if ($_ -like "cs_ds/*") { "0$_" }
        elseif ($_ -like "数统/*") { "1$_" }
        else { "2$_" }
    })
}

function Select-UsableSources {
    param([string[]]$Candidates)

    $usable = New-Object System.Collections.Generic.List[string]
    $deferred = New-Object System.Collections.Generic.List[string]
    foreach ($path in $Candidates) {
        if ($usable.Count -ge $MaxSourceFiles) {
            $deferred.Add($path)
            Write-Log ("Deferred source because this run reached MaxSourceFiles: {0}" -f $path)
            continue
        }
        try {
            $full = Get-SafeRepoPath -Root $script:RepoRoot -RelativePath $path
            if ($MaxSourcePathChars -gt 0 -and $full.Length -ge $MaxSourcePathChars) {
                $deferred.Add($path)
                Write-Log ("Skipped long-path source ({0} chars): {1}" -f $full.Length, $path)
                continue
            }
            $item = Get-Item -LiteralPath $full
            if ($MaxSourceBytes -gt 0 -and $item.Length -gt $MaxSourceBytes) {
                $deferred.Add($path)
                Write-Log ("Skipped oversized source ({0:N1} MB): {1}" -f ($item.Length / 1MB), $path)
                continue
            }
            $usable.Add($path)
        } catch {
            $deferred.Add($path)
            Write-Log ("Skipped source after path/file error: {0}; {1}" -f $path, $_.Exception.Message)
        }
    }

    return [PSCustomObject]@{
        Usable = @($usable)
        Deferred = @($deferred | Sort-Object -Unique)
    }
}

function Get-WorkingPaths {
    param([string]$WorkingDirectory)

    $paths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($args in @(
        @("-c", "core.quotePath=false", "diff", "--name-only"),
        @("-c", "core.quotePath=false", "diff", "--cached", "--name-only"),
        @("-c", "core.quotePath=false", "ls-files", "--others", "--exclude-standard")
    )) {
        foreach ($path in Get-GitLines -WorkingDirectory $WorkingDirectory -GitArgs $args) {
            if (-not [string]::IsNullOrWhiteSpace($path)) {
                [void]$paths.Add((Normalize-RelativePath $path))
            }
        }
    }
    return @($paths | Sort-Object)
}

function Assert-MaintenanceSurfaceClean {
    $conflicts = @(Get-WorkingPaths -WorkingDirectory $script:RepoRoot | Where-Object { Test-AllowedMaintenancePath $_ })
    if ($conflicts.Count -gt 0) {
        throw ("Maintenance files already contain local changes; refusing to overwrite them: {0}" -f ($conflicts -join ", "))
    }
}

function New-Resolver {
    param([string]$WorkingDirectory)

    $inventory = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $basenames = @{}
    $tracked = @(Get-GitLines -WorkingDirectory $WorkingDirectory -GitArgs @("-c", "core.quotePath=false", "ls-files", "--cached"))
    $newMaintenance = @(Get-GitLines -WorkingDirectory $WorkingDirectory -GitArgs @("-c", "core.quotePath=false", "ls-files", "--others", "--exclude-standard") |
        Where-Object { Test-AllowedMaintenancePath $_ })
    foreach ($path in @($tracked + $newMaintenance)) {
        $normalized = Normalize-RelativePath $path
        if ([string]::IsNullOrWhiteSpace($normalized)) { continue }
        [void]$inventory.Add($normalized)
        $leaf = [System.IO.Path]::GetFileName($normalized)
        $stem = [System.IO.Path]::GetFileNameWithoutExtension($normalized)
        foreach ($key in @($leaf, $stem)) {
            if (-not $basenames.ContainsKey($key)) {
                $basenames[$key] = New-Object System.Collections.Generic.List[string]
            }
            $basenames[$key].Add($normalized)
        }
    }
    return [PSCustomObject]@{
        Inventory = $inventory
        Basenames = $basenames
    }
}

function Get-WikiTargetText {
    param([string]$RawTarget)

    $target = $RawTarget.Trim()
    $aliasIndex = $target.IndexOf("|")
    if ($aliasIndex -ge 0) { $target = $target.Substring(0, $aliasIndex) }
    $anchorIndex = $target.IndexOf("#")
    if ($anchorIndex -ge 0) { $target = $target.Substring(0, $anchorIndex) }
    $target = $target.Trim()
    if ([string]::IsNullOrWhiteSpace($target)) { return "" }
    try { $target = [System.Uri]::UnescapeDataString($target) } catch { }
    return Normalize-RelativePath $target
}

function Resolve-WikiTarget {
    param(
        [string]$RawTarget,
        [string]$SourcePath,
        [object]$Resolver
    )

    $target = Get-WikiTargetText $RawTarget
    if ([string]::IsNullOrWhiteSpace($target)) {
        return (Normalize-RelativePath $SourcePath)
    }

    $candidates = New-Object System.Collections.Generic.List[string]
    $rootTarget = Normalize-PathSegments $target
    if ($rootTarget) {
        $candidates.Add($rootTarget)
        if (-not $rootTarget.EndsWith(".md", [System.StringComparison]::OrdinalIgnoreCase)) {
            $candidates.Add("$rootTarget.md")
        }
    }

    $sourceDirectory = [System.IO.Path]::GetDirectoryName((Normalize-RelativePath $SourcePath)) -replace "\\", "/"
    if (-not [string]::IsNullOrWhiteSpace($sourceDirectory)) {
        $relativeTarget = Normalize-PathSegments "$sourceDirectory/$target"
        if ($relativeTarget) {
            $candidates.Add($relativeTarget)
            if (-not $relativeTarget.EndsWith(".md", [System.StringComparison]::OrdinalIgnoreCase)) {
                $candidates.Add("$relativeTarget.md")
            }
        }
    }

    foreach ($candidate in $candidates) {
        if ($Resolver.Inventory.Contains($candidate)) { return $candidate }
    }

    $leaf = [System.IO.Path]::GetFileName($target)
    if ($Resolver.Basenames.ContainsKey($leaf)) {
        $matches = @($Resolver.Basenames[$leaf] | Sort-Object -Unique)
        if ($matches.Count -eq 1) { return $matches[0] }
    }
    if ($Resolver.Basenames.ContainsKey("$leaf.md")) {
        $matches = @($Resolver.Basenames["$leaf.md"] | Sort-Object -Unique)
        if ($matches.Count -eq 1) { return $matches[0] }
    }
    return $null
}

function Get-WikiLinks {
    param([string]$Text)
    return @([regex]::Matches($Text, "!?\[\[([^\]]+)\]\]") | ForEach-Object { $_.Groups[1].Value })
}

function Test-WikiLayerLinks {
    param([string]$WorkingDirectory)

    $resolver = New-Resolver -WorkingDirectory $WorkingDirectory
    $maintenanceFiles = @($resolver.Inventory | Where-Object {
        (Test-AllowedMaintenancePath $_) -and $_.EndsWith(".md", [System.StringComparison]::OrdinalIgnoreCase)
    } | Sort-Object)
    $errors = New-Object System.Collections.Generic.List[string]
    $linkCount = 0
    foreach ($path in $maintenanceFiles) {
        $full = Get-SafeRepoPath -Root $WorkingDirectory -RelativePath $path
        $text = Get-Content -LiteralPath $full -Raw -Encoding UTF8
        foreach ($target in Get-WikiLinks $text) {
            $linkCount++
            if ($null -eq (Resolve-WikiTarget -RawTarget $target -SourcePath $path -Resolver $resolver)) {
                $errors.Add("$path -> [[$target]]")
            }
        }
    }
    if ($errors.Count -gt 0) {
        $sample = @($errors | Select-Object -First 20) -join "; "
        throw ("Wiki link validation failed for {0} link(s): {1}" -f $errors.Count, $sample)
    }
    Write-Log ("FULL_LINK_SCAN=PASS ({0} files, {1} links)" -f $maintenanceFiles.Count, $linkCount)
    return $resolver
}

function Get-AddedLines {
    param(
        [string]$WorkingDirectory,
        [string]$Path
    )

    $tracked = Invoke-GitRaw -WorkingDirectory $WorkingDirectory -GitArgs @("ls-files", "--error-unmatch", "--", $Path)
    if ($tracked.ExitCode -ne 0) {
        $full = Get-SafeRepoPath -Root $WorkingDirectory -RelativePath $Path
        return @(Get-Content -LiteralPath $full -Encoding UTF8)
    }

    $diff = Get-GitLines -WorkingDirectory $WorkingDirectory -GitArgs @("diff", "--unified=0", "--no-color", "--", $Path)
    return @($diff | Where-Object { $_.StartsWith("+") -and -not $_.StartsWith("+++") } | ForEach-Object { $_.Substring(1) })
}

function Test-AddedLinks {
    param(
        [string]$WorkingDirectory,
        [string[]]$ChangedPaths,
        [object]$Resolver
    )

    $errors = New-Object System.Collections.Generic.List[string]
    foreach ($path in $ChangedPaths) {
        if (-not $path.EndsWith(".md", [System.StringComparison]::OrdinalIgnoreCase)) { continue }
        foreach ($line in Get-AddedLines -WorkingDirectory $WorkingDirectory -Path $path) {
            foreach ($target in Get-WikiLinks $line) {
                $plainTarget = Get-WikiTargetText $target
                if (-not [string]::IsNullOrWhiteSpace($plainTarget) -and -not $plainTarget.Contains("/")) {
                    $errors.Add("non-path link in $path -> [[$target]]")
                    continue
                }
                if ($null -eq (Resolve-WikiTarget -RawTarget $target -SourcePath $path -Resolver $Resolver)) {
                    $errors.Add("missing target in $path -> [[$target]]")
                }
            }
        }
    }
    if ($errors.Count -gt 0) {
        throw ("Added-link validation failed: {0}" -f ((@($errors | Select-Object -First 20)) -join "; "))
    }
    Write-Log "ADDED_LINK_SCAN=PASS"
}

function Test-ChangedConceptCards {
    param(
        [string]$WorkingDirectory,
        [string[]]$ChangedPaths,
        [object]$Resolver
    )

    $requiredHeadings = @("一句话解释", "前置知识", "关联课程", "常见题型", "已有笔记链接")
    foreach ($path in $ChangedPaths) {
        if (-not $path.StartsWith("00-Wiki/Concepts/", [System.StringComparison]::OrdinalIgnoreCase)) { continue }
        $full = Get-SafeRepoPath -Root $WorkingDirectory -RelativePath $path
        $text = Get-Content -LiteralPath $full -Raw -Encoding UTF8
        foreach ($heading in $requiredHeadings) {
            if ($text -notmatch ("(?m)^##\s+{0}\s*$" -f [regex]::Escape($heading))) {
                throw "Concept card '$path' is missing required heading '$heading'."
            }
        }

        $section = [regex]::Match($text, "(?ms)^##\s+已有笔记链接\s*\r?\n(?<body>.*?)(?=^##\s+|\z)")
        if (-not $section.Success) {
            throw "Concept card '$path' has no readable source-link section."
        }
        $sourceTargets = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($target in Get-WikiLinks $section.Groups["body"].Value) {
            $resolved = Resolve-WikiTarget -RawTarget $target -SourcePath $path -Resolver $Resolver
            if ($resolved -and -not $resolved.StartsWith("00-Wiki/", [System.StringComparison]::OrdinalIgnoreCase)) {
                [void]$sourceTargets.Add($resolved)
            }
        }
        if ($sourceTargets.Count -lt 2) {
            throw "Concept card '$path' must link at least two real notes or course resources in 已有笔记链接."
        }
    }
    Write-Log "CONCEPT_CARD_SCAN=PASS"
}

function New-CodexPrompt {
    param(
        [datetime]$Slot,
        [string[]]$SourcePaths
    )

    $payload = [PSCustomObject]@{
        scheduled_slot = $Slot.ToString("o")
        source_files = $SourcePaths
    } | ConvertTo-Json -Depth 5

    $template = @'
你正在一个隔离的 Git worktree 中执行半月一次的 Obsidian Wiki 维护。

请基于 JSON 中列出的这半个月新增或改动的 Markdown 笔记和 PDF，直接维护 Wiki 层。

硬性规则：
- 不修改课程笔记正文、PDF 或其他资料，不移动或删除任何文件。
- 对课程源文件保持字节级只读：不要格式化、统一换行，也不要补文件末尾的换行；脚本会核对 SHA256。
- source_files 中可能含有尚未被 Git 跟踪的本地资料；可只读参考，但不要为其新增 Wiki 链接。新增链接目标必须已被 Git 跟踪，或是本轮新增的允许维护文件；可用 `git ls-files --error-unmatch -- <路径>` 只读核对。
- 只允许修改或新增：
  - `00-Wiki/**`
  - `cs_ds/**/00-*索引.md`
  - `数统/**/00-*索引.md`
- 优先细化 `cs_ds` 和 `数统`；Business-BA 只做轻量导航。
- 所有新增 Obsidian 双链都使用从仓库根目录开始的路径式目标，避免重名歧义。
- 新增或更新概念卡片时，保留低维护模板：一句话解释、前置知识、关联课程、常见题型、已有笔记链接。
- 每张新增或更新的概念卡片在“已有笔记链接”中至少链接 2 个真实存在且不位于 `00-Wiki` 的笔记或课程资料。
- 只做文件编辑和本地校验；不要运行 git add、commit、push、pull、merge、reset、restore 或 worktree 命令。
- 不安装依赖，不访问网络，不修改任务脚本或配置文件。
- 没有值得维护的知识入口时可以保持零改动。

建议流程：
1. 只读检查 source_files 和现有 Wiki/索引。
2. 按需更新 `00-Wiki/Home.md`、学科导航和复习看板入口。
3. 更新对应课程的 `00-*索引.md`，加入近期重点主题。
4. 只新增或更新少量跨课程、高频、易忘的概念卡片。
5. 检查每个新增 `[[...]]` 目标确实存在，并确认 git 状态只包含允许的维护面。

输入 JSON：

```json
__SOURCE_PAYLOAD__
```
'@
    return $template.Replace("__SOURCE_PAYLOAD__", $payload)
}

function Copy-SourceOverlay {
    param(
        [string]$Worktree,
        [string[]]$SourcePaths
    )

    $hashes = @{}
    foreach ($path in $SourcePaths) {
        $source = Get-SafeRepoPath -Root $script:RepoRoot -RelativePath $path
        $destination = Get-SafeRepoPath -Root $Worktree -RelativePath $path
        $parent = Split-Path -Parent $destination
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
        [System.IO.File]::Copy($source, $destination, $true)
        $hashes[$path] = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash
    }
    return $hashes
}

function Assert-SourceOverlayUnchanged {
    param(
        [string]$Worktree,
        [hashtable]$Hashes
    )

    foreach ($path in $Hashes.Keys) {
        $full = Get-SafeRepoPath -Root $Worktree -RelativePath $path
        if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
            throw "Codex deleted source file: $path"
        }
        $after = (Get-FileHash -LiteralPath $full -Algorithm SHA256).Hash
        if ($after -ne $Hashes[$path]) {
            throw "Codex modified source file: $path"
        }
    }
}

function Remove-AutomationWorktree {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) { return }
    $fullRoot = [System.IO.Path]::GetFullPath($script:WorktreeRoot).TrimEnd("\", "/")
    $fullPath = [System.IO.Path]::GetFullPath($Path)
    $prefix = $fullRoot + [System.IO.Path]::DirectorySeparatorChar
    if (-not $fullPath.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        Write-Log ("Refusing to remove unexpected worktree path: {0}" -f $fullPath)
        return
    }
    $result = Invoke-GitRaw -GitArgs @("worktree", "remove", "--force", "--", $fullPath)
    if ($result.ExitCode -ne 0) {
        Write-Log ("Unable to remove temporary worktree: {0}" -f ($result.Output -join "; "))
    }
    [void](Invoke-GitRaw -GitArgs @("worktree", "prune"))
}

function Invoke-CodexAttempt {
    param(
        [int]$Attempt,
        [string]$BaseCommit,
        [datetime]$Slot,
        [string[]]$SourcePaths
    )

    $worktree = Join-Path $script:WorktreeRoot ("run-{0}-{1}" -f (Get-Date -Format "yyyyMMdd-HHmmss"), ([guid]::NewGuid().ToString("N")))
    Write-Log ("Creating isolated worktree for Codex attempt {0}: {1}" -f $Attempt, $worktree)
    Invoke-Git -GitArgs @("-c", "core.longpaths=true", "worktree", "add", "--detach", $worktree, $BaseCommit) | Out-Null
    $script:ActiveWorktree = $worktree

    try {
        $sourceHashes = Copy-SourceOverlay -Worktree $worktree -SourcePaths $SourcePaths
        $prompt = New-CodexPrompt -Slot $Slot -SourcePaths $SourcePaths
        $promptPath = Join-Path $script:PromptRoot ("semimonthly-wiki-{0}-attempt{1}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss"), $Attempt)
        $outputPath = Join-Path $script:PromptRoot ("semimonthly-wiki-{0}-attempt{1}-result.txt" -f (Get-Date -Format "yyyyMMdd-HHmmss"), $Attempt)
        [System.IO.File]::WriteAllText($promptPath, $prompt, [System.Text.UTF8Encoding]::new($false))

        Write-Log ("Starting Codex attempt {0}/{1}. Prompt: {2}" -f $Attempt, $CodexAttempts, $promptPath)
        $oldPreference = $ErrorActionPreference
        $ErrorActionPreference = "Continue"
        try {
            $codexOutput = $prompt | & $CodexPath exec --ephemeral --color never --approve-for-me --cd $worktree --output-last-message $outputPath - 2>&1
            $codexCode = $LASTEXITCODE
        } finally {
            $ErrorActionPreference = $oldPreference
        }
        foreach ($line in @($codexOutput | Select-Object -Last 80)) {
            if ($null -ne $line -and -not [string]::IsNullOrWhiteSpace($line.ToString())) {
                Write-Log ("codex: {0}" -f $line.ToString())
            }
        }
        if ($codexCode -ne 0) {
            throw "Codex exited with code $codexCode."
        }

        Assert-SourceOverlayUnchanged -Worktree $worktree -Hashes $sourceHashes
        $staged = @(Get-GitLines -WorkingDirectory $worktree -GitArgs @("-c", "core.quotePath=false", "diff", "--cached", "--name-only"))
        if ($staged.Count -gt 0) {
            throw ("Codex staged files despite the prompt: {0}" -f ($staged -join ", "))
        }

        $overlaySet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($path in $SourcePaths) { [void]$overlaySet.Add($path) }
        $changed = @(Get-WorkingPaths -WorkingDirectory $worktree | Where-Object { -not $overlaySet.Contains($_) })
        $invalid = @($changed | Where-Object { -not (Test-AllowedMaintenancePath $_) })
        if ($invalid.Count -gt 0) {
            throw ("Codex changed files outside the maintenance surface: {0}" -f ($invalid -join ", "))
        }
        if ($changed.Count -gt 100) {
            throw "Codex changed $($changed.Count) maintenance files; automatic limit is 100."
        }
        foreach ($path in $changed) {
            $full = Get-SafeRepoPath -Root $worktree -RelativePath $path
            if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
                throw "Deleting or moving maintenance files is not allowed: $path"
            }
        }

        $diffCheck = Invoke-GitRaw -WorkingDirectory $worktree -GitArgs (@("diff", "--check", "--") + $changed)
        if ($diffCheck.ExitCode -ne 0) {
            throw ("git diff --check failed: {0}" -f ($diffCheck.Output -join "; "))
        }
        $resolver = Test-WikiLayerLinks -WorkingDirectory $worktree
        Test-AddedLinks -WorkingDirectory $worktree -ChangedPaths $changed -Resolver $resolver
        Test-ChangedConceptCards -WorkingDirectory $worktree -ChangedPaths $changed -Resolver $resolver

        return [PSCustomObject]@{
            Worktree = $worktree
            ChangedPaths = $changed
        }
    } catch {
        Remove-AutomationWorktree -Path $worktree
        $script:ActiveWorktree = $null
        throw
    }
}

function New-ApplyBackup {
    param([string[]]$Paths)

    $backupDir = Join-Path $script:BackupRoot ("backup-{0}-{1}" -f (Get-Date -Format "yyyyMMdd-HHmmss"), ([guid]::NewGuid().ToString("N")))
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
    $entries = New-Object System.Collections.Generic.List[object]
    foreach ($path in $Paths) {
        $current = Get-SafeRepoPath -Root $script:RepoRoot -RelativePath $path
        $existed = Test-Path -LiteralPath $current -PathType Leaf
        if ($existed) {
            $backup = Get-SafeRepoPath -Root $backupDir -RelativePath $path
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backup) | Out-Null
            [System.IO.File]::Copy($current, $backup, $true)
        }
        $entries.Add([PSCustomObject]@{ Path = $path; Existed = $existed })
    }
    return [PSCustomObject]@{ Directory = $backupDir; Entries = $entries.ToArray() }
}

function Restore-AppliedChanges {
    param([object]$Context)

    if ($null -eq $Context) { return }
    Write-Log "Restoring task-owned changes after a pre-commit failure."
    foreach ($entry in $Context.Entries) {
        $destination = Get-SafeRepoPath -Root $script:RepoRoot -RelativePath $entry.Path
        if ($entry.Existed) {
            $backup = Get-SafeRepoPath -Root $Context.Directory -RelativePath $entry.Path
            [System.IO.File]::Copy($backup, $destination, $true)
        } elseif (Test-Path -LiteralPath $destination -PathType Leaf) {
            Remove-Item -LiteralPath $destination -Force
        }
    }
    [void](Invoke-GitRaw -GitArgs (@("restore", "--staged", "--") + @($Context.Entries | ForEach-Object { $_.Path })))
}

function Apply-WorktreeChanges {
    param(
        [string]$Worktree,
        [string[]]$Paths
    )

    $context = New-ApplyBackup -Paths $Paths
    try {
        foreach ($path in $Paths) {
            $source = Get-SafeRepoPath -Root $Worktree -RelativePath $path
            $destination = Get-SafeRepoPath -Root $script:RepoRoot -RelativePath $path
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
            [System.IO.File]::Copy($source, $destination, $true)
        }
    } catch {
        Restore-AppliedChanges -Context $context
        throw
    }
    return $context
}

function Complete-Slot {
    param(
        [hashtable]$State,
        [datetime]$Slot,
        [string]$ProcessedCommit,
        [string[]]$DeferredSources
    )

    $State["LastSuccessTime"] = (Get-Date).ToString("o")
    $State["LastCompletedSlot"] = $Slot.ToString("o")
    $State["LastProcessedCommit"] = $ProcessedCommit
    $State["DeferredSources"] = @($DeferredSources | Sort-Object -Unique)
    $State["RepoRoot"] = $script:RepoRoot
    $State["Remote"] = $Remote
    $State["Branch"] = $Branch
    foreach ($key in @("PendingCommit", "PendingBaseCommit", "PendingSlot", "PendingDeferredSources")) {
        [void]$State.Remove($key)
    }
    Save-State -State $State
}

function Resume-PendingPush {
    param([hashtable]$State)

    if (-not $State.ContainsKey("PendingCommit")) { return $false }
    $pending = [string]$State["PendingCommit"]
    $base = [string]$State["PendingBaseCommit"]
    $slot = [datetime]::Parse([string]$State["PendingSlot"])
    $deferred = if ($State.ContainsKey("PendingDeferredSources")) { @($State["PendingDeferredSources"]) } else { @() }

    Invoke-GitWithRetry -GitArgs @("fetch", $Remote) | Out-Null
    $head = Get-HeadCommit
    $remoteHead = Get-RemoteCommit
    if ($remoteHead -eq $pending) {
        Write-Log "Pending Wiki commit is already present on the remote; finalizing state."
        Complete-Slot -State $State -Slot $slot -ProcessedCommit $pending -DeferredSources $deferred
        return $true
    }
    if ($head -ne $pending -or $remoteHead -ne $base) {
        throw "Pending Wiki commit cannot be pushed automatically because HEAD or the remote changed."
    }

    Invoke-GitWithRetry -GitArgs @("push", $Remote, "$Branch`:$Branch") | Out-Null
    Complete-Slot -State $State -Slot $slot -ProcessedCommit $pending -DeferredSources $deferred
    Write-Log ("Recovered and pushed pending Wiki commit {0}." -f $pending)
    return $true
}

try {
    Initialize-LocalPaths
    $script:Mutex = New-Object System.Threading.Mutex($false, "Local\JAYJIAOlearning-SemimonthlyWiki")
    if (-not $script:Mutex.WaitOne(0)) {
        Write-Log "Another semimonthly Wiki run is active; exiting without error."
        exit 0
    }

    Set-Location -LiteralPath $script:RepoRoot
    Write-Log ("Starting semimonthly Wiki maintenance in {0}. Fallback={1}; DryRun={2}" -f $script:RepoRoot, $Fallback.IsPresent, $DryRun.IsPresent)
    $inside = (& git rev-parse --is-inside-work-tree 2>$null)
    if ($LASTEXITCODE -ne 0 -or $inside -ne "true") {
        throw "RepoRoot is not a Git working tree: $script:RepoRoot"
    }

    if ($ValidateOnly) {
        [void](Test-WikiLayerLinks -WorkingDirectory $script:RepoRoot)
        Write-Log "Current Wiki layer validation completed."
        exit 0
    }

    $state = Get-State
    if (-not $DryRun -and (Resume-PendingPush -State $state)) {
        exit 0
    }

    $slot = Get-LatestDueSlot
    if (-not $ForceDue -and $state.ContainsKey("LastCompletedSlot")) {
        $lastSlot = [datetime]::Parse([string]$state["LastCompletedSlot"])
        if ($lastSlot -ge $slot) {
            Write-Log ("No run is due. Last completed slot: {0}; latest slot: {1}." -f $lastSlot, $slot)
            exit 0
        }
    }
    Write-Log ("Processing scheduled slot {0}." -f $slot.ToString("yyyy-MM-dd HH:mm"))

    $candidates = @(Get-SourceCandidates -State $state)
    $selection = Select-UsableSources -Candidates $candidates
    Write-Log ("Source inventory: {0} usable, {1} deferred/skipped." -f $selection.Usable.Count, $selection.Deferred.Count)
    foreach ($path in $selection.Usable) {
        Write-Log ("source: {0}" -f $path)
    }
    if ($DryRun) {
        Write-Log "[dry-run] Codex, commit, push, and state updates were skipped."
        exit 0
    }

    if (-not (Test-Path -LiteralPath $CodexPath -PathType Leaf)) {
        throw "Codex CLI not found: $CodexPath"
    }
    Invoke-Git -GitArgs @("config", "core.longpaths", "true") | Out-Null
    Invoke-GitWithRetry -GitArgs @("fetch", $Remote) | Out-Null
    Assert-BranchSynchronized
    Assert-MaintenanceSurfaceClean
    $baseCommit = Get-HeadCommit
    if ($PreflightOnly) {
        Write-Log ("Preflight passed on {0} at {1}; no Wiki files or state were changed." -f $Branch, $baseCommit)
        exit 0
    }

    if ($selection.Usable.Count -eq 0) {
        Complete-Slot -State $state -Slot $slot -ProcessedCommit $baseCommit -DeferredSources $selection.Deferred
        Write-Log "No usable Markdown/PDF source changes; slot marked complete."
        exit 0
    }

    $result = $null
    $lastError = $null
    for ($attempt = 1; $attempt -le $CodexAttempts; $attempt++) {
        try {
            $result = Invoke-CodexAttempt -Attempt $attempt -BaseCommit $baseCommit -Slot $slot -SourcePaths $selection.Usable
            break
        } catch {
            $lastError = $_
            Write-Log ("Codex attempt {0}/{1} failed: {2}" -f $attempt, $CodexAttempts, $_.Exception.Message)
            if ($attempt -lt $CodexAttempts -and $CodexRetryDelaySeconds -gt 0) {
                Write-Log ("Retrying Codex in {0}s." -f $CodexRetryDelaySeconds)
                Start-Sleep -Seconds $CodexRetryDelaySeconds
            }
        }
    }
    if ($null -eq $result) {
        throw ("All Codex attempts failed. Last error: {0}" -f $lastError.Exception.Message)
    }
    $script:ActiveWorktree = $result.Worktree

    if ($result.ChangedPaths.Count -eq 0) {
        Complete-Slot -State $state -Slot $slot -ProcessedCommit $baseCommit -DeferredSources $selection.Deferred
        Write-Log "Codex found no Wiki maintenance changes to apply."
        exit 0
    }

    if ((Get-HeadCommit) -ne $baseCommit) {
        throw "HEAD changed while Codex was running; refusing to apply generated files."
    }
    Assert-MaintenanceSurfaceClean
    $script:ApplyContext = Apply-WorktreeChanges -Worktree $result.Worktree -Paths $result.ChangedPaths

    $diffCheck = Invoke-GitRaw -GitArgs (@("diff", "--check", "--") + $result.ChangedPaths)
    if ($diffCheck.ExitCode -ne 0) {
        throw ("Applied changes failed git diff --check: {0}" -f ($diffCheck.Output -join "; "))
    }
    Invoke-Git -GitArgs (@("add", "--") + $result.ChangedPaths) | Out-Null
    $stagedCheck = Invoke-GitRaw -GitArgs (@("diff", "--cached", "--check", "--") + $result.ChangedPaths)
    if ($stagedCheck.ExitCode -ne 0) {
        throw ("Staged Wiki changes failed git diff --check: {0}" -f ($stagedCheck.Output -join "; "))
    }
    $message = "wiki: automatic links {0}" -f (Get-Date -Format "yyyy-MM-dd")
    Invoke-Git -GitArgs (@("commit", "--only", "-m", $message, "--") + $result.ChangedPaths) | Out-Null
    $newCommit = Get-HeadCommit
    $script:CommitCreated = $true

    $commitPaths = @(Get-GitLines -GitArgs @("-c", "core.quotePath=false", "diff-tree", "--no-commit-id", "--name-only", "-r", $newCommit))
    $invalidCommitPaths = @($commitPaths | Where-Object { -not (Test-AllowedMaintenancePath $_) })
    if ($invalidCommitPaths.Count -gt 0) {
        throw ("Created commit contains paths outside the maintenance surface: {0}" -f ($invalidCommitPaths -join ", "))
    }

    $state["PendingCommit"] = $newCommit
    $state["PendingBaseCommit"] = $baseCommit
    $state["PendingSlot"] = $slot.ToString("o")
    $state["PendingDeferredSources"] = @($selection.Deferred)
    Save-State -State $state

    Invoke-GitWithRetry -GitArgs @("fetch", $Remote) | Out-Null
    $remoteBeforePush = Get-RemoteCommit
    if ($remoteBeforePush -ne $baseCommit) {
        throw "Remote changed after the Wiki commit was created. Push stopped; no automatic merge will be attempted."
    }
    Invoke-GitWithRetry -GitArgs @("push", $Remote, "$Branch`:$Branch") | Out-Null
    Complete-Slot -State $state -Slot $slot -ProcessedCommit $newCommit -DeferredSources $selection.Deferred
    Write-Log ("Semimonthly Wiki maintenance committed and pushed: {0}" -f $newCommit)
} catch {
    if ($null -ne $script:ApplyContext -and -not $script:CommitCreated) {
        try { Restore-AppliedChanges -Context $script:ApplyContext } catch { Write-Log ("Rollback warning: {0}" -f $_.Exception.Message) }
    }
    Write-Log ("ERROR: {0} at {1}" -f $_.Exception.Message, $_.InvocationInfo.PositionMessage)
    exit 1
} finally {
    if ($script:ActiveWorktree) {
        Remove-AutomationWorktree -Path $script:ActiveWorktree
        $script:ActiveWorktree = $null
    }
    if ($script:Mutex) {
        try { $script:Mutex.ReleaseMutex() } catch { }
        $script:Mutex.Dispose()
    }
}
