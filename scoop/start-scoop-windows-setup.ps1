function Get-ScoopShims {
    $root = if ($env:SCOOP) { $env:SCOOP } else { Join-Path $env:USERPROFILE "scoop" }
    Join-Path $root "shims"
}

# Rebuild this session's PATH from the registry (picks up paths added by installers)
# and make sure scoop's shims folder is always on it. Some installers rewrite PATH
# and can drop the shims entry, which makes 'scoop' disappear mid-script.
function Sync-Path {
    $shims   = Get-ScoopShims
    $machine = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    $user    = [Environment]::GetEnvironmentVariable("PATH", "User")

    if ((Test-Path $shims) -and ($user -split ";" -notcontains $shims)) {
        Write-Warning "Scoop shims were missing from your user PATH. Restoring: $shims"
        $user = (@($shims) + ($user -split ";" | Where-Object { $_ })) -join ";"
        [Environment]::SetEnvironmentVariable("PATH", $user, "User")
    }

    $env:PATH = (@($shims, $user, $machine) | Where-Object { $_ }) -join ";"
}

function Ensure-Scoop {
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host "Scoop is already installed. Skipping."
        return
    }

    Write-Host "Installing Scoop ..."
    # Allow local scripts for this user (needed by scoop's shims)
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)

    $installer = Invoke-RestMethod -Uri https://get.scoop.sh
    if ($isAdmin) {
        # Scoop refuses to install from an elevated shell unless -RunAsAdmin is passed
        & ([scriptblock]::Create($installer)) -RunAsAdmin
    } else {
        & ([scriptblock]::Create($installer))
    }

    # Make scoop usable in this session without reopening PowerShell
    Sync-Path

    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        throw "Scoop installation failed. Fix the error above and re-run this script."
    }
}

function Ensure-ScoopPackage {
    param([Parameter(Mandatory = $true)][string]$Name)

    Sync-Path
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        throw "scoop not found (looked in $(Get-ScoopShims)). Stopping before '$Name'."
    }

    $installed = scoop list 2>$null | ForEach-Object { $_.Name }
    if ($installed -notcontains $Name) {
        Write-Host "Installing $Name ..."
        scoop install $Name
    } else {
        Write-Host "$Name is already installed. Skipping."
    }
}

function Ensure-ScoopBucket {
    param([Parameter(Mandatory = $true)][string]$Name)

    $buckets = scoop bucket list 2>$null | ForEach-Object { $_.Name }
    if ($buckets -notcontains $Name) {
        Write-Host "Adding bucket $Name ..."
        scoop bucket add $Name
    } else {
        Write-Host "Bucket $Name already exists. Skipping."
    }
}

function Ensure-WingetPackage {
    param(
        [Parameter(Mandatory = $true)][string]$Id,
        [string]$Source = "winget"
    )

    winget list -e --id $Id --source $Source *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Installing $Id (winget) ..."
        winget install -e --id $Id --source $Source --accept-package-agreements --accept-source-agreements
    } else {
        Write-Host "$Id is already installed. Skipping."
    }
}

Ensure-Scoop

# git must be installed before adding buckets (scoop clones buckets with git)
Ensure-ScoopPackage "git"

Ensure-ScoopBucket "main"
Ensure-ScoopBucket "extras"
Ensure-ScoopBucket "versions"
Ensure-ScoopBucket "java"
Ensure-ScoopBucket "nerd-fonts"

Ensure-ScoopPackage "Hack-NF"
Ensure-ScoopPackage "php"
Ensure-ScoopPackage "composer"
Ensure-ScoopPackage "apache"
Ensure-ScoopPackage "openssl"
Ensure-ScoopPackage "openjdk21"
Ensure-ScoopPackage "maven"
Ensure-ScoopPackage "nodejs-lts"
Ensure-ScoopPackage "nvm"
# "idea-ultimate" no longer exists in extras; "idea" is the unified IntelliJ IDEA (Ultimate with license)
Ensure-ScoopPackage "idea"
Ensure-ScoopPackage "gcloud"

Ensure-ScoopPackage "yarn"
Ensure-ScoopPackage "mongodb-database-tools"
Ensure-ScoopPackage "mongosh"
Ensure-ScoopPackage "mongodb-compass"

Ensure-ScoopPackage "postman"
Ensure-ScoopPackage "jmeter"
Ensure-ScoopPackage "insomnia"

Ensure-ScoopPackage "gh"
Ensure-ScoopPackage "filezilla"
Ensure-ScoopPackage "cloudflared"
Ensure-ScoopPackage "terraform"
Ensure-ScoopPackage "autohotkey"

Ensure-ScoopPackage "openshot"
Ensure-ScoopPackage "googlechrome"
Ensure-ScoopPackage "ffmpeg"

Ensure-ScoopPackage "chatgpt"
Ensure-ScoopPackage "claude-code"
Ensure-ScoopPackage "7zip"
Ensure-ScoopPackage "zoom"
Ensure-ScoopPackage "vlc"

Ensure-ScoopPackage "rainmeter"
Ensure-ScoopPackage "nosleep"
Ensure-ScoopPackage "sudo"
Ensure-ScoopPackage "notepadplusplus"

Ensure-ScoopPackage "kafka"
Ensure-ScoopPackage "gradle"
Ensure-ScoopPackage "scala"
Ensure-ScoopPackage "mysql"
Ensure-ScoopPackage "kubectl"
Ensure-ScoopPackage "minikube"
Ensure-ScoopPackage "vscode"
Ensure-ScoopPackage "jq"
Ensure-ScoopPackage "gitleaks"

Ensure-ScoopPackage "python"
python -m pip install --upgrade pywhatkit

# LibreOffice is a very heavy install, uncomment in case you really want it.
# Ensure-ScoopPackage "libreoffice"

# These packages are not available with scoop
# Ensure-WingetPackage "Docker.DockerDesktop"
Ensure-WingetPackage "TortoiseGit.TortoiseGit"
Ensure-WingetPackage "Google.GoogleDrive"
# WhatsApp (Microsoft Store). For the beta use 9NBDXK71NK08 instead.
Ensure-WingetPackage "9NKSQGP7F2NH" -Source "msstore"

Read-Host "Press Enter to exit..."