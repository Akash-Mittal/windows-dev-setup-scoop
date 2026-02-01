# Requires administrator privileges to run
# This script will attempt to elevate itself if not already running as administrator.

# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Attempting to elevate script to Administrator privileges..."
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}

# Set execution policy for the current session to allow scripts to run
Set-ExecutionPolicy Bypass -Scope Process -Force

Write-Host "Running fire.ps1 with Administrator privileges."

# Run the Scoop setup script (if uncommented)
# . "$PSScriptRoot\scoop\windows-dev-env-setup-with-scoop.ps1"

# --- Chrome Startup Scripts ---
$chromeScriptsFolder = Join-Path $PSScriptRoot "chrome"
if (Test-Path $chromeScriptsFolder) {
    Get-ChildItem "$chromeScriptsFolder\*.ps1" | ForEach-Object { # Changed to *.ps1
        Write-Host "Starting Chrome script: $($_.BaseName).ps1"
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($_.FullName)`"" -NoNewWindow
    }
    Write-Host "Chrome startup scripts started successfully!"
} else {
    Write-Warning "Chrome scripts folder not found at '$chromeScriptsFolder'. Skipping Chrome startup scripts."
}


# --- Rainmeter Skins Copy ---
$rainmeterFolder = Join-Path $PSScriptRoot "rainmeter"
$rainmeterScoopFolder = Join-Path $env:USERPROFILE "scoop\apps\rainmeter\current\Skins\rainmeter"
if (Test-Path $rainmeterFolder) {
    Copy-Item -Path $rainmeterFolder -Destination $rainmeterScoopFolder -Recurse -Force
    Write-Host "rainmeter folder copied to Rainmeter Scoop Skins successfully!"
} else {
    Write-Warning "Rainmeter skins folder not found at '$rainmeterFolder'. Skipping Rainmeter skin copy."
}


# --- Start Applications ---
$startupItems = @(
    @{ Name = "Rainmeter"; Path = Join-Path $env:USERPROFILE "scoop\apps\rainmeter\current\rainmeter.exe" },
    @{ Name = "IntelliJ IDEA Ultimate"; Path = Join-Path $env:USERPROFILE "scoop\apps\idea-ultimate\current\IDE\bin\idea64.exe" },
    @{ Name = "Notepad++"; Path = Join-Path $env:USERPROFILE "scoop\apps\notepadplusplus\current\notepad++.exe" },
    @{ Name = "Docker Desktop"; Path = "C:\Program Files\Docker\Docker\Docker Desktop.exe" },
    @{ Name = "ChatGPT"; Path = Join-Path $env:USERPROFILE "scoop\apps\chatgpt\current\ChatGPT.exe" },
    @{ Name = "NoSleep"; Path = Join-Path $env:USERPROFILE "scoop\apps\nosleep\current\NoSleep.exe" },
    @{ Name = "Google Drive"; Path = "C:\Program Files\Google\Drive\GoogleDrive.exe" },
    @{ Name = "Clear Cache"; Path = Join-Path $PSScriptRoot "clear-cache\clear-cache.ps1" }, # Changed to .ps1
    @{ Name = "Start Docker Compose"; Path = Join-Path $PSScriptRoot "docker\start-docker-compose.ps1" }, # Changed to .ps1
    @{ Name = "Git Update and Build"; Path = Join-Path $PSScriptRoot "github\gitupdateandbuild.ps1" }, # Changed to .ps1
    @{ Name = "Scoop Update"; Path = Join-Path $PSScriptRoot "scoop\sccop.update.ps1" }
)

foreach ($item in $startupItems) {
    if (Test-Path $item.Path) {
        Write-Host "Starting $($item.Name) from $($item.Path)"
        # For .ps1 files, execute with powershell.exe
        if ($item.Path.EndsWith(".ps1")) {
            Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($item.Path)`"" -NoNewWindow
        }
        # For .bat files (if any remain, or other executables)
        else {
            Start-Process -FilePath $item.Path
        }
    } else {
        Write-Warning "$($item.Name) not found at $($item.Path). Application not started."
    }
}

# --- Process GitHub Repositories ---
$gitRepoHome = $env:GIT_REPO_HOME
$gitUpdateAndBuildScript = Join-Path $PSScriptRoot "github\gitupdateandbuild.ps1" # Changed to .ps1

if ([string]::IsNullOrEmpty($gitRepoHome)) {
    Write-Warning "GIT_REPO_HOME environment variable is not set. Skipping GitHub repository updates."
} elseif (-not (Test-Path $gitRepoHome -PathType Container)) {
    Write-Warning "GIT_REPO_HOME path '$gitRepoHome' does not exist or is not a directory. Skipping GitHub repository updates."
} elseif (-not (Test-Path $gitUpdateAndBuildScript)) {
    Write-Warning "gitupdateandbuild.ps1 not found at '$gitUpdateAndBuildScript'. Skipping GitHub repository updates."
} else {
    Write-Host "Processing GitHub repositories in '$gitRepoHome'..."
    Get-ChildItem -Path $gitRepoHome -Directory | ForEach-Object {
        $repoPath = $_.FullName
        Write-Host "Running gitupdateandbuild.ps1 for repository: '$repoPath'"
        # Execute the PowerShell script with -WorkingDirectory
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$gitUpdateAndBuildScript`" -WorkingDirectory `"$repoPath`"" -NoNewWindow -Wait
    }
    Write-Host "Finished processing GitHub repositories."
}

# --- Notepad++ File Associations ---
$notepadAssocScript = Join-Path $PSScriptRoot "misc\defualt-file-extension.notepad.ps1"
if (Test-Path $notepadAssocScript) {
    Write-Host "Running Notepad++ file association script..."
    # The script itself handles elevation, so we just execute it.
    & "$notepadAssocScript"
    Write-Host "Notepad++ file association script finished."
} else {
    Write-Warning "Notepad++ file association script not found at '$notepadAssocScript'. Skipping file associations."
}
