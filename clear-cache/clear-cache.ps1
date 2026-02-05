Set-Location $PSScriptRoot

$ErrorActionPreference = "SilentlyContinue"

# User temp folders
Remove-Item "$env:TEMP\*" -Recurse -Force
Remove-Item "$env:LOCALAPPDATA\Temp\*" -Recurse -Force

# Explorer thumbnail cache
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" -Force

# Chrome cache
Remove-Item "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force
Remove-Item "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache\*" -Recurse -Force

# Windows Update download cache (user accessible)
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\SoftwareDistribution\Download\*" -Recurse -Force

# Recent files
Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Recurse -Force
Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\*" -Recurse -Force
Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\CustomDestinations\*" -Recurse -Force

Read-Host "Press Enter to exit..."