# Requires administrator privileges if Scoop is installed system-wide or if certain updates require it.

Write-Host "==============================="
Write-Host "Updating Scoop packages"
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host "==============================="

# --- Check if Scoop exists ---
try {
    # Attempt to find scoop.cmd in PATH
    $scoopPath = (Get-Command scoop.cmd -ErrorAction Stop).Path
    Write-Host "Scoop found at: $scoopPath"
}
catch {
    Write-Warning "Scoop not found. Skipping update."
    exit 0
}

# --- Update Scoop itself ---
Write-Host "Updating Scoop..."
try {
    scoop update -ErrorAction Stop
    Write-Host "Scoop updated successfully."
}
catch {
    Write-Warning "scoop update failed: $($_.Exception.Message)"
}

# --- Update all installed packages ---
Write-Host "Updating all Scoop packages..."
try {
    scoop update * -ErrorAction Stop
    Write-Host "All Scoop packages updated successfully."
}
catch {
    Write-Warning "Some packages failed to update: $($_.Exception.Message)"
}

Write-Host "==============================="
Write-Host "Scoop update finished"
Write-Host "==============================="
