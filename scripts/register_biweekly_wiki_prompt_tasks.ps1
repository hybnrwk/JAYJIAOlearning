param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [int]$LookbackDays = 15,
    [string]$TaskName = "JAYJIAOlearning Biweekly Wiki Prompt",
    [string]$FallbackTaskName = "JAYJIAOlearning Biweekly Wiki Prompt Fallback",
    [datetime]$ScheduleAnchor = ([datetime]"2026-05-10T18:30:00"),
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

function Quote-TaskArgument {
    param([string]$Value)

    if ($Value -notmatch '[\s"]') {
        return $Value
    }
    return '"' + ($Value -replace '"', '\"') + '"'
}

function New-TaskArgumentString {
    param([string[]]$TaskArgs)

    return ($TaskArgs | ForEach-Object { Quote-TaskArgument $_ }) -join " "
}

$repo = (Resolve-Path -LiteralPath $RepoRoot).Path
$promptScript = Join-Path $repo "scripts\biweekly_wiki_prompt.ps1"
if (-not (Test-Path -LiteralPath $promptScript -PathType Leaf)) {
    throw "Missing prompt script: $promptScript"
}

$powerShell = Join-Path $env:SystemRoot "System32\WindowsPowerShell\v1.0\powershell.exe"
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

$baseArgs = @(
    "-NoProfile",
    "-ExecutionPolicy", "Bypass",
    "-File", $promptScript,
    "-RepoRoot", $repo,
    "-LookbackDays", $LookbackDays.ToString(),
    "-ScheduleAnchor", $ScheduleAnchor.ToString("s"),
    "-OpenPrompt"
)

$mainArguments = New-TaskArgumentString -TaskArgs $baseArgs
$fallbackArguments = New-TaskArgumentString -TaskArgs ($baseArgs + "-LogonFallback")

if ($DryRun) {
    Write-Output "[dry-run] Would register task: $TaskName"
    Write-Output "[dry-run] Main action: $powerShell $mainArguments"
    Write-Output "[dry-run] Main trigger: every 2 weeks on Sunday at $($ScheduleAnchor.ToString('yyyy-MM-dd HH:mm:ss'))"
    Write-Output "[dry-run] Would register task: $FallbackTaskName"
    Write-Output "[dry-run] Fallback action: $powerShell $fallbackArguments"
    Write-Output "[dry-run] Fallback trigger: at logon with 10 minute delay"
    exit 0
}

$mainAction = New-ScheduledTaskAction -Execute $powerShell -Argument $mainArguments
$fallbackAction = New-ScheduledTaskAction -Execute $powerShell -Argument $fallbackArguments

$mainTrigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 2 -DaysOfWeek Sunday -At $ScheduleAnchor
$fallbackTrigger = New-ScheduledTaskTrigger -AtLogOn -User $user
$fallbackTrigger.Delay = "PT10M"

$settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -MultipleInstances IgnoreNew `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 20) `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries

$principal = New-ScheduledTaskPrincipal -UserId $user -LogonType Interactive -RunLevel Limited

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $mainAction `
    -Trigger $mainTrigger `
    -Settings $settings `
    -Principal $principal `
    -Description "Generate a biweekly manual Codex prompt for Obsidian wiki maintenance." `
    -Force | Out-Null

Register-ScheduledTask `
    -TaskName $FallbackTaskName `
    -Action $fallbackAction `
    -Trigger $fallbackTrigger `
    -Settings $settings `
    -Principal $principal `
    -Description "Generate the biweekly wiki prompt at next logon only if the scheduled run was missed or failed." `
    -Force | Out-Null

Get-ScheduledTask -TaskName $TaskName, $FallbackTaskName |
    Select-Object TaskName, State |
    Format-Table -AutoSize
