# Restarts the Docker Compose environment in this folder.
# Waits for the Docker engine first, since at login Docker Desktop is still starting.
param(
    [string]$WorkingDirectory = $PSScriptRoot,
    [switch]$ResetData,
    [int]$WaitSeconds = 300
)

Set-Location $WorkingDirectory -ErrorAction Stop

Write-Host "Waiting up to $WaitSeconds s for the Docker engine ..."
$deadline = (Get-Date).AddSeconds($WaitSeconds)
while ($true) {
    cmd.exe /c "docker info >nul 2>&1"
    if ($LASTEXITCODE -eq 0) { break }
    if ((Get-Date) -gt $deadline) {
        Write-Error "Docker engine not ready after $WaitSeconds s. Is Docker Desktop running?"
        exit 1
    }
    Start-Sleep -Seconds 5
}

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
if ($LASTEXITCODE -ne 0) {
    Write-Error "docker compose up failed with exit code $LASTEXITCODE"
    exit 1
}

Write-Host "Docker Compose environment started."
