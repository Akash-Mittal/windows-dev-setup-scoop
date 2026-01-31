<#
===================================================================================
Purpose:
    Idempotent developer workstation setup using Scoop on Windows.
    Each install is guarded with a check so you can re-run safely without duplicates.

Prereqs:
    - Windows PowerShell (Run as Current User)
    - Internet connectivity
    - Scoop should be installed (see bootstrap below if not)

Notes:
    - We use Scoop buckets to access broader app manifests (main/extras/versions/java).
    - For each tool, we check presence via `scoop list` against the manifest name.
===================================================================================
#>

# ----------------------------------------
# Optional helper: idempotent Scoop install
# ----------------------------------------
function Ensure-ScoopPackage {
    param([Parameter(Mandatory = $true)][string]$Name)

    $installed = scoop list 2>$null | ForEach-Object { $_.Name }
    if ($installed -notcontains $Name) {
        Write-Host "Installing $Name ..."
        scoop install $Name
    } else {
        Write-Host "$Name is already installed. Skipping installation."
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

# ----------------------------------------
# Bootstrap: Ensure Scoop is installed
# ----------------------------------------
# If Scoop is not installed, uncomment the two lines below and run them once.
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# ----------------------------------------
# Configure Scoop buckets
# ----------------------------------------
Ensure-ScoopBucket -Name "main"
Ensure-ScoopBucket -Name "extras"
Ensure-ScoopBucket -Name "versions"
Ensure-ScoopBucket -Name "java"

# ----------------------------------------
# Core developer tools
# ----------------------------------------
Ensure-ScoopPackage -Name "git"
Ensure-ScoopPackage -Name "openjdk21"
Ensure-ScoopPackage -Name "maven"
Ensure-ScoopPackage -Name "nodejs-lts"
Ensure-ScoopPackage -Name "nvm"
Ensure-ScoopPackage -Name "idea-ultimate"
Ensure-ScoopPackage -Name "gcloud"

# ----------------------------------------
# Additional tools
# ----------------------------------------
Ensure-ScoopPackage -Name "yarn"
Ensure-ScoopPackage -Name "mongodb-database-tools"
Ensure-ScoopPackage -Name "mongosh"
Ensure-ScoopPackage -Name "postman"
Ensure-ScoopPackage -Name "jmeter"
Ensure-ScoopPackage -Name "insomnia"

Ensure-ScoopPackage -Name "gh"
Ensure-ScoopPackage -Name "filezilla"
Ensure-ScoopPackage -Name "cloudflared"
Ensure-ScoopPackage -Name "terraform"
Ensure-ScoopPackage -Name "AutoHotkey"

# ----------------------------------------
# Insomnia dotenv plugin (manual step)
# ----------------------------------------
# npm install insomnia-plugin-dotenv
