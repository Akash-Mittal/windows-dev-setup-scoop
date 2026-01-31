# ============================================================
# fire.ps1 - Main setup script
# ============================================================

# Dot-source your main setup script (runs in current scope)
# . "$PSScriptRoot\windows-dev-setup-scoop\windows-dev-env-setup-with-scoop.ps1"

# ============================================================
# Copy Chrome startup BAT files to Windows Startup folder
# ============================================================

# Source folder (relative to this script)
$chromeBatFolder = Join-Path $PSScriptRoot "chrome-default-startup"

# User Startup folder (dynamic)
$startupFolder = [Environment]::GetFolderPath("Startup")

# Copy all .bat files to Startup folder
Get-ChildItem "$chromeBatFolder\*.bat" | ForEach-Object {
    Copy-Item $_.FullName -Destination $startupFolder -Force
}

Write-Host "Chrome startup scripts copied successfully!"

# ============================================================
# Copy Rainmeter automation folder to Scoop Rainmeter Skins
# ============================================================

# Source folder (relative to this script)
$rainmeterFolder = Join-Path $PSScriptRoot "rainmeter-automation"

# Destination folder in Scoop Rainmeter Skins (dynamic using user profile)
$rainmeterScoopFolder = Join-Path $env:USERPROFILE "scoop\apps\rainmeter\current\Skins\rainmeter-automation"

# Copy the entire folder recursively
Copy-Item -Path $rainmeterFolder -Destination $rainmeterScoopFolder -Recurse -Force

Write-Host "rainmeter-automation folder copied to Rainmeter Scoop Skins successfully!"
