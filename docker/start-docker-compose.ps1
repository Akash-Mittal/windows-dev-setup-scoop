# PowerShell script to start Docker Compose environment.

param(
    [string]$WorkingDirectory = (Get-Location).Path
)

Write-Host "Changing directory to: $WorkingDirectory"
Set-Location $WorkingDirectory -ErrorAction Stop

Write-Host "Bringing down existing Docker Compose services and removing orphans..."
docker compose down --remove-orphans

Write-Host "Removing any existing containers with conflicting names..."
docker rm -f xcp-local-mongo-database-container -ErrorAction SilentlyContinue
docker rm -f xcp-local-activemq -ErrorAction SilentlyContinue
docker rm -f xcp-local-frontend -ErrorAction SilentlyContinue

Write-Host "Starting Docker Compose services..."
docker compose up --build -d

Write-Host "Docker Compose environment started."
