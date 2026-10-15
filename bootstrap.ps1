# One command for a new machine, from a normal (non-admin) PowerShell window:
#
#   irm https://raw.githubusercontent.com/Akash-Mittal/windows-dev-setup-scoop/main/bootstrap.ps1 | iex
#
# Installs Scoop and git, clones this repo into <root_dir>\windows-dev-setup, then runs setup.ps1.
# root_dir comes from windows_dev_setup.csv on GitHub (general,root_dir); if that drive does not
# exist, your user folder is used. To clone somewhere else, set $env:DEV_SETUP_DIR first.
# This file runs before the repo exists, so it cannot use lib\common.ps1.

$ErrorActionPreference = "Stop"

$repoUrl = "https://github.com/Akash-Mittal/windows-dev-setup-scoop.git"
$csvUrl  = "https://raw.githubusercontent.com/Akash-Mittal/windows-dev-setup-scoop/main/windows_dev_setup.csv"

function Get-DefaultTargetDir {
    $rootDir = ""
    $projectDir = "windows-dev-setup"
    try {
        $rows = (Invoke-RestMethod -Uri $csvUrl) | ConvertFrom-Csv
        $rootRow = $rows | Where-Object { $_.worksheet -eq "general" -and $_.config -eq "root_dir" } | Select-Object -First 1
        $nameRow = $rows | Where-Object { $_.worksheet -eq "general" -and $_.config -eq "project_dir_name" } | Select-Object -First 1
        if ($rootRow) { $rootDir = "$($rootRow.value)".Trim() }
        if ($nameRow -and "$($nameRow.value)".Trim()) { $projectDir = "$($nameRow.value)".Trim() }
    } catch {
        Write-Warning "Could not read root_dir from $csvUrl. Using your user folder."
    }

    if ($rootDir -match "^[A-Za-z]:$") { $rootDir += "\" }
    if (-not $rootDir -or $rootDir.StartsWith("~") -or -not [IO.Directory]::Exists($rootDir)) { $rootDir = $env:USERPROFILE }
    Join-Path $rootDir $projectDir
}

$targetDir = if ($env:DEV_SETUP_DIR) { $env:DEV_SETUP_DIR } else { Get-DefaultTargetDir }

function Update-SessionPath {
    $scoopRoot = if ($env:SCOOP) { $env:SCOOP } else { Join-Path $env:USERPROFILE "scoop" }
    $env:PATH = (@(
        (Join-Path $scoopRoot "shims"),
        [Environment]::GetEnvironmentVariable("PATH", "User"),
        [Environment]::GetEnvironmentVariable("PATH", "Machine")
    ) | Where-Object { $_ }) -join ";"
}

try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
} catch {
    Write-Warning "Could not set the execution policy: $($_.Exception.Message)"
}

Update-SessionPath
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop ..."
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)
    $installer = Invoke-RestMethod -Uri https://get.scoop.sh
    if ($isAdmin) {
        & ([scriptblock]::Create($installer)) -RunAsAdmin
    } else {
        & ([scriptblock]::Create($installer))
    }
    Update-SessionPath
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Installing git ..."
    scoop install git
    Update-SessionPath
}

if (Test-Path (Join-Path $targetDir ".git")) {
    Write-Host "Repo already at $targetDir, pulling ..."
    git -C $targetDir pull --ff-only
} else {
    Write-Host "Cloning into $targetDir ..."
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $targetDir) | Out-Null
    git clone $repoUrl $targetDir
}

Write-Host "Running setup ..."
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $targetDir "setup.ps1")
