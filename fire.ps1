
# Run the Scoop setup script (if uncommented)
 . "$PSScriptRoot\scoop\windows-dev-env-setup-with-scoop.ps1"

git config core.longpaths true
git config --global core.longpaths true
#
# --- Start Applications ---
$startupItems = @(
    @{ Name = "Chrome Browser"; Path = Join-Path $PSScriptRoot "chrome\chrome-open-profiles.ps1" },
    @{ Name = "Rainmeter"; Path = Join-Path $env:USERPROFILE "scoop\apps\rainmeter\current\rainmeter.exe" },
    @{ Name = "IntelliJ IDEA Ultimate"; Path = Join-Path $env:USERPROFILE "scoop\apps\idea-ultimate\current\IDE\bin\idea64.exe" },
    @{ Name = "Notepad++"; Path = Join-Path $env:USERPROFILE "scoop\apps\notepadplusplus\current\notepad++.exe" },
    @{ Name = "Docker Desktop"; Path = "C:\Program Files\Docker\Docker\Docker Desktop.exe" },
    @{ Name = "NoSleep"; Path = Join-Path $env:USERPROFILE "scoop\apps\nosleep\current\NoSleep.exe" },
    @{ Name = "Clear Cache"; Path = Join-Path $PSScriptRoot "clear-cache\clear-cache.ps1" }, # Changed to .ps1
    @{ Name = "Start Docker Compose"; Path = Join-Path $PSScriptRoot "docker\start-docker-compose.ps1" }, # Changed to .ps1
    @{ Name = "Scoop Update"; Path = Join-Path $PSScriptRoot "scoop\sccop.update.ps1" },
    @{ Name = "Git Update and Build"; Path = Join-Path $PSScriptRoot "github\gitupdateandbuild.ps1" }, # Changed to .ps1
    @{ Name = "VPN Login AutoHotkey"; Path = Join-Path $PSScriptRoot "autohotkey\vpn-login.ahk" }
)

foreach ($item in $startupItems) {
    if (Test-Path $item.Path) {
        Write-Host "Starting $($item.Name) from $($item.Path)"
        # For .ps1 files, execute with powershell.exe
        if ($item.Path.EndsWith(".ps1")) {
            Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($item.Path)`"" -NoNewWindow
        }
        # For .ahk files, execute directly
        elseif ($item.Path.EndsWith(".ahk")) {
            Start-Process -FilePath $item.Path
        }
        # For other executables
        else {
            Start-Process -FilePath $item.Path
        }
    } else {
        Write-Warning "$($item.Name) not found at $($item.Path). Application not started."
    }
}

$rainmeterFolder = Join-Path $PSScriptRoot "rainmeter\trump-skins"
$rainmeterScoopFolder = Join-Path $env:USERPROFILE "scoop\apps\rainmeter\current\Skins\rainmeter"
if (Test-Path $rainmeterFolder) {
    Copy-Item -Path $rainmeterFolder -Destination $rainmeterScoopFolder -Recurse -Force
    Write-Host "rainmeter folder copied to Rainmeter Scoop Skins successfully!"
} else {
    Write-Warning "Rainmeter skins folder not found at '$rainmeterFolder'. Skipping Rainmeter skin copy."
}
