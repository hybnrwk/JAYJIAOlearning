param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [int]$LookbackDays = 15,
    [switch]$LogonFallback,
    [switch]$OpenPrompt,
    [switch]$DryRun,
    [datetime]$ScheduleAnchor = ([datetime]"2026-05-10T18:30:00"),
    [int]$MaxNotes = 40,
    [int]$MaxExcerptChars = 2500,
    [string]$OutputDir = ""
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

function Initialize-Paths {
    $script:RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
    $logDir = Join-Path $env:LOCALAPPDATA "JAYJIAOlearning"
    try {
        New-Item -ItemType Directory -Force -Path $logDir | Out-Null
    } catch {
        $logDir = Join-Path (Join-Path $script:RepoRoot ".git") "logs"
        New-Item -ItemType Directory -Force -Path $logDir | Out-Null
    }

    $script:LogPath = Join-Path $logDir "biweekly-wiki-prompt.log"
    $script:StatePath = Join-Path $logDir "biweekly-wiki-prompt-state.json"
    if ([string]::IsNullOrWhiteSpace($OutputDir)) {
        $script:PromptDir = Join-Path $logDir "wiki-prompts"
    } else {
        $script:PromptDir = $OutputDir
    }
}

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

function Get-GitOutput {
    param([string[]]$GitArgs)

    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $output = & git @GitArgs 2>&1
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $oldPreference
    }

    if ($code -ne 0) {
        throw ("git {0} failed with exit code {1}: {2}" -f ($GitArgs -join " "), $code, ($output -join "`n"))
    }

    $clean = New-Object System.Collections.Generic.List[string]
    foreach ($line in $output) {
        if ($null -eq $line) { continue }
        $text = $line.ToString()
        if ($text -like "warning:*") {
            Write-Log ("git: {0}" -f $text)
            continue
        }
        if (-not [string]::IsNullOrWhiteSpace($text)) {
            $clean.Add($text)
        }
    }
    return @($clean)
}

function Normalize-RelativePath {
    param([string]$Path)

    $p = ($Path -replace "\\", "/").Trim()
    while ($p.StartsWith("./")) {
        $p = $p.Substring(2)
    }
    return $p
}

function ConvertTo-RepoRelativePath {
    param([string]$Path)

    $full = if ([System.IO.Path]::IsPathRooted($Path)) {
        [System.IO.Path]::GetFullPath($Path)
    } else {
        [System.IO.Path]::GetFullPath((Join-Path $script:RepoRoot $Path))
    }

    $root = [System.IO.Path]::GetFullPath($script:RepoRoot)
    if (-not $root.EndsWith([System.IO.Path]::DirectorySeparatorChar)) {
        $root = $root + [System.IO.Path]::DirectorySeparatorChar
    }
    if (-not $full.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Path is outside repo: $Path"
    }

    return $full.Substring($root.Length).Replace([System.IO.Path]::DirectorySeparatorChar, "/")
}

function Get-RepoPath {
    param([string]$RelativePath)
    return Join-Path $script:RepoRoot ($RelativePath -replace "/", [System.IO.Path]::DirectorySeparatorChar)
}

function Test-IndexNotePath {
    param([string]$Path)

    $p = Normalize-RelativePath $Path
    $leaf = ($p -split "/")[-1]
    return ($leaf -like "00-*索引.md")
}

function Test-SourceNotePath {
    param([string]$Path)

    $p = Normalize-RelativePath $Path
    if (-not $p.EndsWith(".md", [System.StringComparison]::OrdinalIgnoreCase)) { return $false }
    if ($p -eq "README.md" -or $p -eq "AGENTS.md") { return $false }
    if ($p.StartsWith("00-Wiki/", [System.StringComparison]::OrdinalIgnoreCase)) { return $false }
    if ($p.StartsWith("scripts/", [System.StringComparison]::OrdinalIgnoreCase)) { return $false }
    if (Test-IndexNotePath $p) { return $false }
    return $true
}

function Add-CandidatePath {
    param(
        [System.Collections.Generic.HashSet[string]]$Set,
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) { return }
    $p = Normalize-RelativePath $Path
    if (Test-SourceNotePath $p) {
        $full = Get-RepoPath $p
        if (Test-Path -LiteralPath $full -PathType Leaf) {
            [void]$Set.Add($p)
        }
    }
}

function Test-CommitExists {
    param([string]$Commit)

    if ([string]::IsNullOrWhiteSpace($Commit)) { return $false }
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        & git cat-file -e "$Commit^{commit}" 2>$null
        return ($LASTEXITCODE -eq 0)
    } catch {
        return $false
    } finally {
        $ErrorActionPreference = $oldPreference
    }
}

function Get-State {
    if (-not (Test-Path -LiteralPath $script:StatePath -PathType Leaf)) {
        return [PSCustomObject]@{}
    }

    try {
        return Get-Content -LiteralPath $script:StatePath -Raw -Encoding UTF8 | ConvertFrom-Json
    } catch {
        Write-Log ("Ignoring unreadable state file: {0}" -f $_.Exception.Message)
        return [PSCustomObject]@{}
    }
}

function Save-SuccessState {
    param(
        [string]$PromptPath,
        [string]$ProcessedCommit
    )

    if ($DryRun) {
        Write-Log "[dry-run] success state not updated."
        return
    }

    $state = [PSCustomObject]@{
        LastSuccessTime = (Get-Date).ToString("o")
        LastPromptPath = $PromptPath
        LastProcessedCommit = $ProcessedCommit
        RepoRoot = $script:RepoRoot
    }
    try {
        $state | ConvertTo-Json | Set-Content -LiteralPath $script:StatePath -Encoding UTF8
    } catch {
        Write-Log ("Unable to write state file: {0}" -f $_.Exception.Message)
    }
}

function Get-LatestBiweeklyScheduledTime {
    $now = Get-Date
    $scheduled = $ScheduleAnchor
    while ($scheduled -gt $now) {
        $scheduled = $scheduled.AddDays(-14)
    }
    while ($scheduled.AddDays(14) -le $now) {
        $scheduled = $scheduled.AddDays(14)
    }
    return $scheduled
}

function Get-RecentSourceNotes {
    param([object]$State)

    $paths = New-Object System.Collections.Generic.HashSet[string]

    if ($State.LastProcessedCommit -and (Test-CommitExists $State.LastProcessedCommit)) {
        $range = "{0}..HEAD" -f $State.LastProcessedCommit
        foreach ($path in Get-GitOutput @("diff", "--name-only", "--diff-filter=ACMRT", $range, "--", "*.md")) {
            Add-CandidatePath $paths $path
        }
    } else {
        if ($State.LastProcessedCommit) {
            Write-Log ("Ignoring invalid LastProcessedCommit in state file: {0}" -f $State.LastProcessedCommit)
        }
        foreach ($path in Get-GitOutput @("log", "--since=$LookbackDays days ago", "--name-only", "--pretty=format:", "--", "*.md")) {
            Add-CandidatePath $paths $path
        }
    }

    foreach ($path in Get-GitOutput @("diff", "--name-only", "--diff-filter=ACMRT", "--", "*.md")) {
        Add-CandidatePath $paths $path
    }
    foreach ($path in Get-GitOutput @("ls-files", "--others", "--exclude-standard", "--", "*.md")) {
        Add-CandidatePath $paths $path
    }

    $cutoff = (Get-Date).AddDays(-1 * $LookbackDays)
    Get-ChildItem -LiteralPath $script:RepoRoot -Recurse -File -Filter "*.md" |
        Where-Object {
            $_.FullName -notmatch "\\.git\\" -and $_.LastWriteTime -ge $cutoff
        } |
        ForEach-Object {
            Add-CandidatePath $paths (ConvertTo-RepoRelativePath $_.FullName)
        }

    $ordered = @($paths | Sort-Object {
        if ($_ -like "cs_ds/*") { "0$_" }
        elseif ($_ -like "数统/*") { "1$_" }
        else { "2$_" }
    } | Select-Object -First $MaxNotes)
    return $ordered
}

function Get-NoteDigest {
    param([string]$RelativePath)

    $full = Get-RepoPath $RelativePath
    $text = Get-Content -LiteralPath $full -Raw -Encoding UTF8
    $title = [System.IO.Path]::GetFileNameWithoutExtension($RelativePath)
    $h1 = [regex]::Match($text, "(?m)^#\s+(.+)$")
    if ($h1.Success) {
        $title = $h1.Groups[1].Value.Trim()
    }

    $headings = @([regex]::Matches($text, "(?m)^#{1,4}\s+(.+)$") | Select-Object -First 25 | ForEach-Object {
        $_.Groups[1].Value.Trim()
    })

    $excerpt = ($text -replace "\r\n", "`n").Trim()
    if ($excerpt.Length -gt $MaxExcerptChars) {
        $excerpt = $excerpt.Substring(0, $MaxExcerptChars) + "`n...[truncated]"
    }

    return [PSCustomObject]@{
        path = ($RelativePath -replace "\.md$", "")
        file = $RelativePath
        title = $title
        domain = if ($RelativePath -like "cs_ds/*") { "cs_ds" } elseif ($RelativePath -like "数统/*") { "数统" } else { "other" }
        headings = $headings
        excerpt = $excerpt
    }
}

function Get-ExistingWikiTargets {
    $targets = New-Object System.Collections.Generic.List[string]
    foreach ($root in @("00-Wiki", "cs_ds", "数统")) {
        $fullRoot = Get-RepoPath $root
        if (-not (Test-Path -LiteralPath $fullRoot)) { continue }
        Get-ChildItem -LiteralPath $fullRoot -Recurse -File -Filter "*.md" | ForEach-Object {
            $rel = ConvertTo-RepoRelativePath $_.FullName
            if ($rel.StartsWith("00-Wiki/", [System.StringComparison]::OrdinalIgnoreCase) -or (Test-IndexNotePath $rel)) {
                $targets.Add(($rel -replace "\.md$", ""))
            }
        }
    }
    return @($targets | Sort-Object -Unique)
}

function Get-WorkingTreeStatus {
    return @(Get-GitOutput @("-c", "core.quotePath=false", "status", "--short"))
}

function New-ManualPrompt {
    param(
        [object[]]$Notes,
        [string[]]$WikiTargets,
        [string[]]$StatusLines
    )

    $payload = [PSCustomObject]@{
        generated_at = (Get-Date).ToString("o")
        repo_root = $script:RepoRoot
        source_notes = $Notes
        existing_wiki_targets = $WikiTargets
        current_git_status = $StatusLines
    } | ConvertTo-Json -Depth 8

    $commitDate = Get-Date -Format "yyyy-MM-dd"
    return @"
# 双周 Wiki 手动维护 Prompt

下面这一段可以直接复制给 Codex。它的目标是手动更新 Wiki 层，不自动碰原始笔记正文。

---

你现在在仓库：$script:RepoRoot

请基于下面 JSON 中的近双周新增/改动 Markdown 笔记，维护 Obsidian Wiki 层。

硬性规则：
- 不修改现有课程笔记正文，不移动任何文件。
- 只允许修改或新增这些维护面：
  - '00-Wiki/**'
  - 'cs_ds/**/00-*索引.md'
  - '数统/**/00-*索引.md'
- 优先细化 `cs_ds` 和 `数统`，Business-BA 只做轻量导航。
- 给 Wiki、课程索引、概念卡片补路径式 Obsidian 双链，避免重名歧义。
- 新知识卡片保持低维护模板：一句话解释、前置知识、关联课程、常见题型、已有笔记链接。
- 每张新增/更新的概念卡片至少链接 2 个真实存在的笔记或课程资料。
- 如果发现当前工作区有与本任务无关的修改，不要回退，不要纳入 commit。
- 完成后做校验：所有新增 '[[...]]' 链接都能落到真实文件，'git status' 中不要混入普通笔记正文改动。

建议流程：
1. 只读检查 'source_notes' 中的文件和现有 Wiki/索引。
2. 更新 '00-Wiki/Home.md'、学科导航、复习看板中的相关入口。
3. 更新对应课程目录的 '00-*索引.md'，添加近期重点主题入口。
4. 按需新增或更新少量概念卡片，优先处理跨课程、高频、易忘概念。
5. 如果要提交，只 stage Wiki/索引维护面，提交信息使用：
   'wiki: biweekly manual links $commitDate'
6. 提交后 push 到 'origin main'。如果本地和远端分叉，停止并说明，不要自动合并。

输入 JSON：

~~~json
$payload
~~~
"@
}

function Save-Prompt {
    param([string]$Text)

    $fileName = "biweekly-wiki-prompt-{0}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss")
    $path = Join-Path $script:PromptDir $fileName
    if ($DryRun) {
        Write-Log ("[dry-run] would write prompt to {0}" -f $path)
        return $path
    }

    New-Item -ItemType Directory -Force -Path $script:PromptDir | Out-Null
    Set-Content -LiteralPath $path -Value $Text -Encoding UTF8
    return $path
}

try {
    Initialize-Paths
    Set-Location -LiteralPath $script:RepoRoot
    Write-Log "Starting biweekly wiki prompt generation in $script:RepoRoot"

    $inside = (& git rev-parse --is-inside-work-tree 2>$null)
    if ($LASTEXITCODE -ne 0 -or $inside -ne "true") {
        throw "RepoRoot is not a Git working tree: $script:RepoRoot"
    }

    $state = Get-State
    if ($LogonFallback) {
        $latestScheduled = Get-LatestBiweeklyScheduledTime
        $lastSuccess = $null
        if ($state.LastSuccessTime) {
            $lastSuccess = [datetime]::Parse($state.LastSuccessTime)
        }
        if ($lastSuccess -and $lastSuccess -ge $latestScheduled) {
            Write-Log ("Logon fallback skipped. Last success {0}; latest scheduled run {1}." -f $lastSuccess, $latestScheduled)
            exit 0
        }
        Write-Log ("Logon fallback active. Latest scheduled run needing coverage: {0}." -f $latestScheduled)
    }

    $sourcePaths = Get-RecentSourceNotes $state
    Write-Log ("Found {0} recent source note(s)." -f $sourcePaths.Count)

    $notes = @($sourcePaths | ForEach-Object { Get-NoteDigest $_ })
    $prompt = New-ManualPrompt $notes (Get-ExistingWikiTargets) (Get-WorkingTreeStatus)
    $promptPath = Save-Prompt $prompt

    if ($OpenPrompt -and -not $DryRun) {
        Start-Process -FilePath "notepad.exe" -ArgumentList @($promptPath) | Out-Null
        Write-Log ("Opened prompt in Notepad: {0}" -f $promptPath)
    } else {
        Write-Log ("Prompt ready: {0}" -f $promptPath)
    }

    $headOutput = @(Get-GitOutput @("rev-parse", "HEAD"))
    $head = $headOutput[0]
    Save-SuccessState $promptPath $head
    Write-Log "Biweekly wiki prompt generation completed."
} catch {
    Write-Log ("ERROR: {0}" -f $_.Exception.Message)
    exit 1
}
