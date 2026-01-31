# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
# run this file twice becouse buckets need git
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

Ensure-ScoopBucket -Name "main"
Ensure-ScoopBucket -Name "extras"
Ensure-ScoopBucket -Name "versions"
Ensure-ScoopBucket -Name "java"

Ensure-ScoopPackage -Name "git"
Ensure-ScoopPackage -Name "openjdk21"
Ensure-ScoopPackage -Name "maven"
Ensure-ScoopPackage -Name "nodejs-lts"
Ensure-ScoopPackage -Name "nvm"
Ensure-ScoopPackage -Name "idea-ultimate"
Ensure-ScoopPackage -Name "gcloud"

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
Ensure-ScoopPackage -Name "autohotkey"

Ensure-ScoopPackage -Name "openshot"
Ensure-ScoopPackage -Name "googlechrome"
Ensure-ScoopPackage -Name "chatgpt"
Ensure-ScoopPackage -Name "7zip"
Ensure-ScoopPackage -Name "zoom"
Ensure-ScoopPackage -Name "vlc"
Ensure-ScoopPackage -Name "libreoffice"
Ensure-ScoopPackage -Name "mongodb-compass"


winget install --id Docker.DockerDesktop -e
winget install --id 9NBDXK71NK08

