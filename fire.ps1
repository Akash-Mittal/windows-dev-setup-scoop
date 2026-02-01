 # . "$PSScriptRoot\scoop\windows-dev-env-setup-with-scoop.ps1"

$chromeBatFolder = Join-Path $PSScriptRoot "chrome"
$startupFolder = [Environment]::GetFolderPath("Startup")
$wshell = New-Object -ComObject WScript.Shell

Get-ChildItem "$chromeBatFolder\*.bat" | ForEach-Object {
    $shortcutPath = Join-Path $startupFolder "$($_.BaseName).lnk"
    $shortcut = $wshell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $_.FullName
    $shortcut.Save()
}
Write-Host "Chrome startup scripts shortcuts created successfully!"

$rainmeterFolder = Join-Path $PSScriptRoot "rainmeter"
$rainmeterScoopFolder = Join-Path $env:USERPROFILE "scoop\apps\rainmeter\current\Skins\rainmeter"
Copy-Item -Path $rainmeterFolder -Destination $rainmeterScoopFolder -Recurse -Force
Write-Host "rainmeter folder copied to Rainmeter Scoop Skins successfully!"

# Create shortcuts in Startup folder
$startupItems = @(
    @{ Name = "Rainmeter"; Path = Join-Path $env:USERPROFILE "scoop\apps\rainmeter\current\rainmeter.exe" },
    @{ Name = "IntelliJ IDEA Ultimate"; Path = Join-Path $env:USERPROFILE "scoop\apps\idea-ultimate\current\IDE\bin\idea64.exe" },
    @{ Name = "Notepad++"; Path = Join-Path $env:USERPROFILE "scoop\apps\notepadplusplus\current\notepad++.exe" },
    @{ Name = "Docker Desktop"; Path = "C:\Program Files\Docker\Docker\Docker Desktop.exe" },
    @{ Name = "ChatGPT"; Path = Join-Path $env:USERPROFILE "scoop\apps\chatgpt\current\ChatGPT.exe" },
    @{ Name = "NoSleep"; Path = Join-Path $env:USERPROFILE "scoop\apps\nosleep\current\NoSleep.exe" },
    @{ Name = "Google Drive"; Path = "C:\Program Files\Google\Drive\GoogleDrive.exe" },
    @{ Name = "Clear Cache"; Path = Join-Path $PSScriptRoot "clear-cache\clear-cache.bat" },
    @{ Name = "Start Docker Compose"; Path = Join-Path $PSScriptRoot "docker\start-docker-compose.bat" },
    @{ Name = "Git Update and Build"; Path = Join-Path $PSScriptRoot "github\gitupdateandbuild.bat" },
    @{ Name = "Scoop Update"; Path = Join-Path $PSScriptRoot "scoop\sccop.update.bat" }
)

foreach ($item in $startupItems) {
    if (Test-Path $item.Path) {
        $shortcutPath = Join-Path $startupFolder "$($item.Name).lnk"
        $shortcut = $wshell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = $item.Path
        $shortcut.Save()
        Write-Host "$($item.Name) shortcut created in Startup folder."
    } else {
        Write-Warning "$($item.Name) not found at $($item.Path). Shortcut not created."
    }
}
