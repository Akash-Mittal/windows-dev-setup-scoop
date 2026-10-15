# Runs at every login (registered by setup.ps1). Silent: never prompts, never stops on a missing app.
#   - starts every enabled row of worksheet startup_apps, in file order
#   - runs scoop/start-scoop-update.ps1 every scoop_update_every_days days
#   - logs to logs\startup-*.log (script output in logs\items\)
#   - shows a self-closing summary when startup_settings,show_summary is true (or with -ShowSummary)
#
# Usage:  powershell -NoProfile -ExecutionPolicy Bypass -File startup.ps1 [-DryRun] [-ShowSummary]
param([switch]$DryRun, [switch]$ShowSummary)

. (Join-Path $PSScriptRoot "lib\common.ps1")

function Invoke-ScoopUpdateIfDue {
    $everyDays = [int](Get-ConfigValue "startup_settings" "scoop_update_every_days" "7")
    if ($everyDays -le 0) { return }

    $stateFile = Join-Path $DevSetupStateDir "last-scoop-update.txt"
    $lastRun = [datetime]::MinValue
    if (Test-Path -LiteralPath $stateFile) {
        [void][datetime]::TryParse((Get-Content -LiteralPath $stateFile -Raw).Trim(), [ref]$lastRun)
    }

    $dueAt = $lastRun.AddDays($everyDays)
    if ((Get-Date) -lt $dueAt) {
        Write-Log ("Scoop update not due until {0:yyyy-MM-dd}" -f $dueAt)
        return
    }

    $updateScript = Join-Path $DevSetupRoot "scoop\start-scoop-update.ps1"
    if ($DryRun) {
        Add-Result "Scoop update" "DryRun" $updateScript
        return
    }
    try {
        Start-DevItem -Name "Scoop update" -Path $updateScript | Out-Null
        New-Item -ItemType Directory -Force -Path $DevSetupStateDir | Out-Null
        Set-Content -LiteralPath $stateFile -Value (Get-Date -Format "o") -Encoding ASCII
        Add-Result "Scoop update" "Started"
    } catch {
        Add-Result "Scoop update" "Failed" "$($_.Exception.Message)"
    }
}

$logFile = Start-DevLog "startup" -Keep 30

try {
    $delay = [int](Get-ConfigValue "startup_settings" "start_delay_seconds" "0")
    if ($delay -gt 0 -and -not $DryRun) {
        Write-Log "Waiting $delay s for the desktop to settle ..."
        Start-Sleep -Seconds $delay
    }

    foreach ($row in Get-ConfigRows "startup_apps") {
        $path = Expand-ConfigPath $row.Value
        if (-not (Test-Path -LiteralPath $path)) {
            Add-Result $row.Config "Skipped" "not found: $path"
            continue
        }
        if ($DryRun) {
            Add-Result $row.Config "DryRun" "$path $($row.Args)".Trim()
            continue
        }
        try {
            Start-DevItem -Name $row.Config -Path $path -Arguments (Expand-ConfigArgs $row.Args) | Out-Null
            Add-Result $row.Config "Started"
        } catch {
            Add-Result $row.Config "Failed" "$($_.Exception.Message)"
        }
    }

    Invoke-ScoopUpdateIfDue
} catch {
    Add-Result "startup" "Failed" "$($_.Exception.Message)"
}

$summary = Get-ResultSummary
Write-Log "Startup finished: $summary"

if ($ShowSummary -or (Test-ConfigTrue "startup_settings" "show_summary" $false)) {
    $timeout = [int](Get-ConfigValue "startup_settings" "summary_timeout_seconds" "30")
    Show-DevSummary -Title "Dev startup" -Text "$summary`n`nLog: $logFile" -TimeoutSeconds $timeout
}
