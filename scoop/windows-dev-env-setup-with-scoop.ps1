function Ensure-ScoopPackage {
    param([Parameter(Mandatory = $true)][string]$Name)

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

scoop bucket add nerd-fonts
scoop install Hack-NF
scoop install php
scoop install composer
scoop install apache

Ensure-ScoopBucket "main"
Ensure-ScoopBucket "extras"
Ensure-ScoopBucket "versions"
Ensure-ScoopBucket "java"

Ensure-ScoopPackage "git"
Ensure-ScoopPackage "openjdk21"
Ensure-ScoopPackage "maven"
Ensure-ScoopPackage "nodejs-lts"
Ensure-ScoopPackage "nvm"
Ensure-ScoopPackage "idea-ultimate"
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

# Libra office is very heavy install, uncomment in case you really want it.
# Ensure-ScoopPackage "libreoffice"

# These packages are not availablle with scoop
winget install -e --id Docker.DockerDesktop
# whatspp beta
# winget install -e --id 9NBDXK71NK08
# winget install Google.Drive

Read-Host "Press Enter to exit..."