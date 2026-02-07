Set-Location $PSScriptRoot
$ErrorActionPreference = "Stop"

$skinsSource = Join-Path $PSScriptRoot "trump-skins"
$documents = [Environment]::GetFolderPath("MyDocuments")
$rainmeterSkins = Join-Path $documents "Rainmeter\Skins"

if (!(Test-Path -LiteralPath $skinsSource)) { Write-Error "Skins source not found: $skinsSource"; exit 1 }

New-Item -ItemType Directory -Force -Path $rainmeterSkins | Out-Null
Copy-Item -LiteralPath $skinsSource -Destination $rainmeterSkins -Recurse -Force

Write-Host "Copied skins to: $rainmeterSkins"
