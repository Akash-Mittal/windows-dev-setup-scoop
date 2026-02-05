Set-Location $PSScriptRoot
$ErrorActionPreference = "Stop"

$firePath = Join-Path $PSScriptRoot "fire.json"
if (!(Test-Path $firePath)) {
    Write-Error "fire.json not found at $firePath"
    exit 1
}

try {
    $fireConfig = Get-Content -Path $firePath -Raw | ConvertFrom-Json
} catch {
    Write-Error "Failed to parse fire.json. $($_.Exception.Message)"
    exit 1
}

if ($fireConfig.installonstartup -eq $true) {
    $scoopSetup = Join-Path $PSScriptRoot "scoop\windows-dev-env-setup-with-scoop.ps1"
    if (!(Test-Path $scoopSetup)) {
        Write-Error "Setup script not found at $scoopSetup"
        exit 1
    }
    . $scoopSetup
}

git config core.longpaths true 2>$null
git config --global core.longpaths true 2>$null

$startupItems = @(
    @{ Name = "Chrome Browser"; Path = Join-Path $PSScriptRoot "chrome\chrome-open-profiles.ps1"; Arguments = "personal work" },
    @{ Name = "Rainmeter"; Path = Join-Path $env:USERPROFILE "scoop\apps\rainmeter\current\rainmeter.exe" },
    @{ Name = "IntelliJ IDEA Ultimate"; Path = Join-Path $env:USERPROFILE "scoop\apps\idea-ultimate\current\IDE\bin\idea64.exe" },
    @{ Name = "Notepad++"; Path = Join-Path $env:USERPROFILE "scoop\apps\notepadplusplus\current\notepad++.exe" },
    @{ Name = "Docker Desktop"; Path = "C:\Program Files\Docker\Docker\Docker Desktop.exe" },
    @{ Name = "NoSleep"; Path = Join-Path $env:USERPROFILE "scoop\apps\nosleep\current\NoSleep.exe" },
    @{ Name = "AutoHotkey"; Path = Join-Path $env:USERPROFILE "scoop\apps\autohotkey\current\v2\AutoHotkey64.exe" ; Arguments = "autohotkey\vpn-login.ahk"},
    @{ Name = "Clear Cache"; Path = Join-Path $PSScriptRoot "clear-cache\clear-cache.ps1" },
    @{ Name = "Start Docker Compose"; Path = Join-Path $PSScriptRoot "docker\start-docker-compose.ps1"; Arguments = "-ResetData:$false" },
    @{ Name = "Scoop Update"; Path = Join-Path $PSScriptRoot "scoop\scoop.update.ps1" },
    @{ Name = "Git Update and Build"; Path = Join-Path $PSScriptRoot "github\gitupdateandbuild.ps1" },
    @{ Name = "MongoDB Compass"; Path = Join-Path $env:LOCALAPPDATA "MongoDBCompass\MongoDBCompass.exe" }
)

foreach ($item in $startupItems) {
    if (!(Test-Path $item.Path)) {
        Write-Warning "$($item.Name) not found at $($item.Path). Application not started."
        continue
    }

    $ext = [IO.Path]::GetExtension($item.Path).ToLowerInvariant()

    if ($ext -eq ".ps1") {
        $argList = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $item.Path)
        if ($item.Arguments) { $argList += $item.Arguments }
        Start-Process -FilePath "powershell.exe" -ArgumentList $argList | Out-Null
        continue
    }

    if ($item.Arguments) {
        Start-Process -FilePath $item.Path -ArgumentList $item.Arguments | Out-Null
    } else {
        Start-Process -FilePath $item.Path | Out-Null
    }
}