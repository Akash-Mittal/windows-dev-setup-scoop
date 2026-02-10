param(
    [string]$WorkingDirectory = $PSScriptRoot,
    [switch]$ResetData
)
$ErrorActionPreference = "Stop"

Set-Location $WorkingDirectory -ErrorAction Stop

Write-Host "Stopping Docker Compose services..."
if ($ResetData) {
    Write-Host "ResetData enabled: removing containers + networks + volumes (DATA WILL BE LOST)."
    docker compose down --remove-orphans --volumes
} else {
    Write-Host "Preserving data: removing containers + networks only (volumes kept)."
    docker compose down --remove-orphans
}

Write-Host "Starting Docker Compose services..."
docker compose up --build -d

Write-Host "Docker Compose environment started."

Read-Host "Press Enter to exit..."