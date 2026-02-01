# PowerShell script to update a Git repository and build the project with Maven.

param(
    [string]$WorkingDirectory = (Get-Location).Path
)

Write-Host "=== Starting update process ==="
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

Write-Host "`nSwitching to repo: $WorkingDirectory"
try {
    Set-Location $WorkingDirectory -ErrorAction Stop
}
catch {
    Write-Error "❌ Repo directory not found: $WorkingDirectory. $($_.Exception.Message)"
    exit 1
}

if (-not (Test-Path ".git" -PathType Container)) {
    Write-Error "❌ Not a git repository: $(Get-Location). Aborting."
    exit 1
}

Write-Host "`nFetching remote updates..."
try {
    git fetch -ErrorAction Stop
    Write-Host "✅ Git fetch complete."
}
catch {
    Write-Error "❌ git fetch failed: $($_.Exception.Message)"
    exit 1
}

Write-Host "`nPulling latest changes from Git..."
try {
    git pull -ErrorAction Stop
    Write-Host "✅ Git pull complete."
}
catch {
    Write-Error "❌ git pull failed: $($_.Exception.Message)"
    exit 1
}

Write-Host "`nRunning Maven build..."
try {
    mvn clean install -Denv=release -ErrorAction Stop
    Write-Host "✅ Maven build complete."
}
catch {
    Write-Error "❌ Maven build failed: $($_.Exception.Message)"
    exit 1
}

Write-Host "`n=== Update complete ==="
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
