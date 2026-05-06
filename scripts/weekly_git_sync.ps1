param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [int64]$MaxBytes = 99614720,
    [string]$Remote = "origin",
    [string]$Branch = "main",
    [string]$CommitPrefix = "weekly sync",
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
    Write-Output $line
}

function Invoke-Git {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$GitArgs)

    $mutating = @("add", "commit", "push", "pull", "fetch", "reset")
    if ($DryRun -and $GitArgs.Count -gt 0 -and $mutating -contains $GitArgs[0]) {
        Write-Log ("[dry-run] git {0}" -f ($GitArgs -join " "))
        return @()
    }

    $output = & git @GitArgs 2>&1
    $code = $LASTEXITCODE
    foreach ($line in $output) {
        if ($null -ne $line -and $line.ToString().Length -gt 0) {
            Write-Log ("git: {0}" -f $line)
        }
    }
    if ($code -ne 0) {
        throw ("git {0} failed with exit code {1}" -f ($GitArgs -join " "), $code)
    }
    return $output
}

function Test-GitQuiet {
    param([string[]]$GitArgs)
    & git @GitArgs *> $null
    return $LASTEXITCODE
}

function Get-RepoPath {
    param([string]$Path)
    return (Join-Path $RepoRoot ($Path -replace "/", [System.IO.Path]::DirectorySeparatorChar))
}

try {
    Set-Location -LiteralPath $RepoRoot
    Write-Log "Starting weekly sync in $RepoRoot"

    $inside = (& git rev-parse --is-inside-work-tree 2>$null)
    if ($LASTEXITCODE -ne 0 -or $inside -ne "true") {
        throw "RepoRoot is not a Git working tree: $RepoRoot"
    }

    $cachedStatus = Test-GitQuiet @("diff", "--cached", "--quiet")
    if ($cachedStatus -eq 1) {
        throw "Index already has staged changes. Aborting to avoid committing unrelated manual staging."
    }
    if ($cachedStatus -ne 0) {
        throw "Unable to inspect staged changes."
    }

    Invoke-Git fetch $Remote | Out-Null

    $upstream = (& git rev-parse --abbrev-ref --symbolic-full-name "@{u}" 2>$null)
    if ($LASTEXITCODE -eq 0 -and $upstream) {
        $counts = (& git rev-list --left-right --count "HEAD...@{u}")
        if ($LASTEXITCODE -eq 0 -and $counts) {
            $parts = $counts.Trim() -split "\s+"
            $ahead = [int]$parts[0]
            $behind = [int]$parts[1]
            if ($behind -gt 0 -and $ahead -eq 0) {
                Write-Log "Local branch is behind upstream; attempting fast-forward pull."
                Invoke-Git pull --ff-only | Out-Null
            } elseif ($behind -gt 0 -and $ahead -gt 0) {
                throw "Local and upstream branches have diverged. Aborting automatic sync."
            }
        }
    }

    $tracked = @(& git -c core.quotePath=false diff --name-only)
    $untracked = @(& git -c core.quotePath=false ls-files --others --exclude-standard)
    $candidates = @($tracked + $untracked | Where-Object { $_ } | Sort-Object -Unique)

    if ($candidates.Count -eq 0) {
        Write-Log "No working tree changes to sync."
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
        exit 0
    }

    foreach ($path in $selected) {
        Invoke-Git add -- $path | Out-Null
    }

    $staged = @(& git -c core.quotePath=false diff --cached --name-only)
    foreach ($path in $staged) {
        $sizeText = (& git cat-file -s ":$path" 2>$null)
        if ($LASTEXITCODE -ne 0 -or -not $sizeText) {
            continue
        }
        $stagedSize = [int64]$sizeText.Trim()
        if ($stagedSize -ge $MaxBytes) {
            Write-Log ("Unstaging oversized Git blob: {0} ({1:N2} MB)" -f $path, ($stagedSize / 1MB))
            Invoke-Git reset -- $path | Out-Null
        }
    }

    $hasStagedChanges = Test-GitQuiet @("diff", "--cached", "--quiet")
    if ($hasStagedChanges -eq 0) {
        Write-Log "Nothing staged after filtering."
        exit 0
    }
    if ($hasStagedChanges -ne 1) {
        throw "Unable to inspect filtered staged changes."
    }

    $message = "{0} {1}" -f $CommitPrefix, (Get-Date -Format "yyyy-MM-dd")
    Invoke-Git commit -m $message | Out-Null
    Invoke-Git push $Remote $Branch | Out-Null

    Write-Log "Weekly sync completed."
} catch {
    Write-Log ("ERROR: {0}" -f $_.Exception.Message)
    exit 1
}
