param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [int64]$MaxBytes = 99614720,
    [string]$Remote = "origin",
    [string]$Branch = "main",
    [string]$CommitPrefix = "weekly sync",
    [switch]$LogonFallback,
    [string]$ScheduledDay = "Sunday",
    [int]$ScheduledHour = 18,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

$LogDir = Join-Path $env:LOCALAPPDATA "JAYJIAOlearning"
try {
    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
} catch {
    $LogDir = Join-Path (Join-Path $RepoRoot ".git") "logs"
    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
}
$script:LogPath = Join-Path $LogDir "weekly-sync.log"
$StatePath = Join-Path $LogDir "weekly-sync-state.json"

function Write-Log {
    param([string]$Message)
    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    if ($script:LogPath) {
        try {
            Add-Content -LiteralPath $script:LogPath -Value $line -Encoding UTF8
        } catch {
            $script:LogPath = $null
        }
    }
    Write-Host $line
}

function Invoke-Git {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$GitArgs)

    $mutating = @("add", "commit", "push", "pull", "fetch", "reset")
    if ($DryRun -and $GitArgs.Count -gt 0 -and $mutating -contains $GitArgs[0]) {
        Write-Log ("[dry-run] git {0}" -f ($GitArgs -join " "))
        return @()
    }

    $result = Invoke-GitRaw @GitArgs
    foreach ($line in $result.Output) {
        Write-Log ("git: {0}" -f $line)
    }
    if ($result.ExitCode -ne 0) {
        throw ("git {0} failed with exit code {1}" -f ($GitArgs -join " "), $result.ExitCode)
    }
    return $result.Output
}

function Invoke-GitRaw {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$GitArgs)

    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $output = & git @GitArgs 2>&1
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $oldPreference
    }

    $clean = New-Object System.Collections.Generic.List[string]
    foreach ($line in $output) {
        if ($null -eq $line) { continue }
        $text = $line.ToString()
        if ([string]::IsNullOrWhiteSpace($text)) { continue }
        if ($text -like "warning:*") {
            Write-Log ("git: {0}" -f $text)
            continue
        }
        $clean.Add($text)
    }

    return [PSCustomObject]@{
        ExitCode = $code
        Output = @($clean)
    }
}

function Get-GitOutput {
    param([string[]]$GitArgs)

    $result = Invoke-GitRaw @GitArgs
    if ($result.ExitCode -ne 0) {
        throw ("git {0} failed with exit code {1}" -f ($GitArgs -join " "), $result.ExitCode)
    }
    return @($result.Output)
}

function Test-GitQuiet {
    param([string[]]$GitArgs)
    $result = Invoke-GitRaw @GitArgs
    return $result.ExitCode
}

function Get-RepoPath {
    param([string]$Path)
    return (Join-Path $RepoRoot ($Path -replace "/", [System.IO.Path]::DirectorySeparatorChar))
}

function Get-LatestScheduledTime {
    $day = [System.Enum]::Parse([System.DayOfWeek], $ScheduledDay, $true)
    $now = Get-Date
    $daysBack = ([int]$now.DayOfWeek - [int]$day + 7) % 7
    $scheduled = $now.Date.AddDays(-$daysBack).AddHours($ScheduledHour)
    if ($scheduled -gt $now) {
        $scheduled = $scheduled.AddDays(-7)
    }
    return $scheduled
}

function Get-LastSuccessTime {
    if (-not (Test-Path -LiteralPath $StatePath -PathType Leaf)) {
        return $null
    }

    try {
        $state = Get-Content -LiteralPath $StatePath -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($state.LastSuccessTime) {
            return [datetime]::Parse($state.LastSuccessTime)
        }
    } catch {
        Write-Log ("Ignoring unreadable state file: {0}" -f $_.Exception.Message)
    }
    return $null
}

function Save-SuccessState {
    if ($DryRun) {
        Write-Log "[dry-run] success state not updated."
        return
    }

    $state = [PSCustomObject]@{
        LastSuccessTime = (Get-Date).ToString("o")
        RepoRoot = $RepoRoot
        Remote = $Remote
        Branch = $Branch
    }
    try {
        $state | ConvertTo-Json | Set-Content -LiteralPath $StatePath -Encoding UTF8
    } catch {
        Write-Log ("Unable to write state file: {0}" -f $_.Exception.Message)
    }
}

try {
    Set-Location -LiteralPath $RepoRoot
    Write-Log "Starting weekly sync in $RepoRoot"

    $inside = (& git rev-parse --is-inside-work-tree 2>$null)
    if ($LASTEXITCODE -ne 0 -or $inside -ne "true") {
        throw "RepoRoot is not a Git working tree: $RepoRoot"
    }

    if ($LogonFallback) {
        $latestScheduled = Get-LatestScheduledTime
        $lastSuccess = Get-LastSuccessTime
        if ($lastSuccess -and $lastSuccess -ge $latestScheduled) {
            Write-Log ("Logon fallback skipped. Last success {0}; latest scheduled run {1}." -f $lastSuccess, $latestScheduled)
            exit 0
        }
        Write-Log ("Logon fallback active. Latest scheduled run needing coverage: {0}." -f $latestScheduled)
    }

    $cachedStatus = Test-GitQuiet @("diff", "--cached", "--quiet")
    if ($cachedStatus -ne 0 -and $cachedStatus -ne 1) {
        throw "Unable to inspect staged changes."
    }

    Invoke-Git fetch $Remote | Out-Null

    $upstreamResult = Invoke-GitRaw rev-parse --abbrev-ref --symbolic-full-name "@{u}"
    if ($upstreamResult.ExitCode -eq 0 -and $upstreamResult.Output.Count -gt 0) {
        $countsResult = Invoke-GitRaw rev-list --left-right --count "HEAD...@{u}"
        if ($countsResult.ExitCode -eq 0 -and $countsResult.Output.Count -gt 0) {
            $counts = $countsResult.Output[0]
            $parts = $counts.Trim() -split "\s+"
            $ahead = [int]$parts[0]
            $behind = [int]$parts[1]
            if ($behind -gt 0 -and $ahead -eq 0) {
                Write-Log "Local branch is behind upstream; attempting fast-forward pull."
                Invoke-Git pull --ff-only | Out-Null
            } elseif ($behind -gt 0 -and $ahead -gt 0) {
                throw "Local and upstream branches have diverged. Aborting automatic sync."
            } elseif ($ahead -gt 0) {
                Write-Log ("Local branch is ahead by {0} commit(s); pushing pending commits." -f $ahead)
                Invoke-Git push $Remote $Branch | Out-Null
            }
        }
    }

    $stagedInitial = @(Get-GitOutput @("-c", "core.quotePath=false", "diff", "--cached", "--name-only"))
    $tracked = @(Get-GitOutput @("-c", "core.quotePath=false", "diff", "--name-only"))
    $untracked = @(Get-GitOutput @("-c", "core.quotePath=false", "ls-files", "--others", "--exclude-standard"))
    $candidates = @($stagedInitial + $tracked + $untracked | Where-Object { $_ } | Sort-Object -Unique)

    if ($candidates.Count -eq 0) {
        Write-Log "No working tree changes to sync."
        Save-SuccessState
        exit 0
    }

    $selected = New-Object System.Collections.Generic.List[string]
    $skipped = New-Object System.Collections.Generic.List[string]

    foreach ($path in $candidates) {
        $fullPath = Get-RepoPath $path
        if (Test-Path -LiteralPath $fullPath -PathType Leaf) {
            $file = Get-Item -LiteralPath $fullPath
            if ($file.Length -ge $MaxBytes) {
                $skipped.Add(("{0} ({1:N2} MB)" -f $path, ($file.Length / 1MB)))
                continue
            }
        } elseif (Test-Path -LiteralPath $fullPath -PathType Container) {
            $skipped.Add(("{0} (directory)" -f $path))
            continue
        }
        $selected.Add($path)
    }

    foreach ($item in $skipped) {
        Write-Log ("Skipped large or unsupported path: {0}" -f $item)
    }

    if ($selected.Count -eq 0) {
        Write-Log "No small files selected for sync."
        Save-SuccessState
        exit 0
    }

    foreach ($path in $selected) {
        Invoke-Git add -- $path | Out-Null
    }

    $staged = @(Get-GitOutput @("-c", "core.quotePath=false", "diff", "--cached", "--name-only"))
    foreach ($path in $staged) {
        $blobResult = Invoke-GitRaw cat-file -s ":$path"
        if ($blobResult.ExitCode -ne 0 -or $blobResult.Output.Count -eq 0) {
            continue
        }
        $stagedSize = [int64]$blobResult.Output[0].Trim()
        if ($stagedSize -ge $MaxBytes) {
            Write-Log ("Unstaging oversized Git blob: {0} ({1:N2} MB)" -f $path, ($stagedSize / 1MB))
            Invoke-Git reset -- $path | Out-Null
        }
    }

    $hasStagedChanges = Test-GitQuiet @("diff", "--cached", "--quiet")
    if ($hasStagedChanges -eq 0) {
        Write-Log "Nothing staged after filtering."
        Save-SuccessState
        exit 0
    }
    if ($hasStagedChanges -ne 1) {
        throw "Unable to inspect filtered staged changes."
    }

    $message = "{0} {1}" -f $CommitPrefix, (Get-Date -Format "yyyy-MM-dd")
    Invoke-Git commit -m $message | Out-Null
    Invoke-Git push $Remote $Branch | Out-Null

    Save-SuccessState
    Write-Log "Weekly sync completed."
} catch {
    Write-Log ("ERROR: {0}" -f $_.Exception.Message)
    exit 1
}
