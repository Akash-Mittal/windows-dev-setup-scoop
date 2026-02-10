Set-Location $PSScriptRoot

$ErrorActionPreference = "SilentlyContinue"
$DebugPreference = "Continue"

function Clear-FolderSafe($path) {
    if (!(Test-Path $path)) {
        Write-Debug "Skip: missing path: $path"
        return @{ Deleted = 0; Failed = 0 }
    }

    Write-Debug "Scanning: $path"
    $deleted = 0
    $failed = 0

    $items = Get-ChildItem -Path $path -Force -Recurse -File -ErrorAction SilentlyContinue
    Write-Debug "Found files: $($items.Count) in $path"

    foreach ($f in $items) {
        try {
            Remove-Item $f.FullName -Force -ErrorAction Stop
            $deleted++
        } catch {
            $failed++
            Write-Error "Failed: $($f.FullName) :: $($_.Exception.Message)"
        }
    }

    Write-Debug "Done: $path | Deleted=$deleted | Failed=$failed"
    return @{ Deleted = $deleted; Failed = $failed }
}

$totalDeleted = 0
$totalFailed = 0

$r = Clear-FolderSafe "$env:TEMP"
$totalDeleted += $r.Deleted; $totalFailed += $r.Failed

$r = Clear-FolderSafe "$env:LOCALAPPDATA\Temp"
$totalDeleted += $r.Deleted; $totalFailed += $r.Failed

$r = Clear-FolderSafe "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
$totalDeleted += $r.Deleted; $totalFailed += $r.Failed

$r = Clear-FolderSafe "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache"
$totalDeleted += $r.Deleted; $totalFailed += $r.Failed

Write-Debug "Summary | Deleted=$totalDeleted | Failed=$totalFailed"

Read-Host "Press Enter to exit..."
