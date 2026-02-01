# Requires administrator privileges to clear system temporary files.
# This script will attempt to elevate itself if not already running as administrator.

# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Attempting to elevate script to Administrator privileges..."
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}

Write-Host "Cleaning temporary files... 🧹"

# --- Clear user temp folder ---
Write-Host "Deleting files in $env:TEMP..."
try {
    Get-ChildItem -Path "$env:TEMP\*" -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "User temp folder cleaned."
}
catch {
    Write-Warning "Failed to clean user temp folder: $($_.Exception.Message)"
}

# --- Clear Windows temp folder ---
Write-Host "Deleting files in C:\Windows\Temp..."
try {
    Get-ChildItem -Path "C:\Windows\Temp\*" -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Windows temp folder cleaned."
}
catch {
    Write-Warning "Failed to clean Windows temp folder: $($_.Exception.Message)"
}

Write-Host "✅ Temp cleanup complete!"
