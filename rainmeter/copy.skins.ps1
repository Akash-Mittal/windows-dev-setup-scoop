$rainmeterFolder = Join-Path $PSScriptRoot "rainmeter\trump-skins"
$rainmeterScoopFolder = Join-Path $env:USERPROFILE "scoop\apps\rainmeter\current\Skins\rainmeter"
if (Test-Path $rainmeterFolder) {
    Copy-Item -Path $rainmeterFolder -Destination $rainmeterScoopFolder -Recurse -Force
} else {
    Write-Warning "rainmeter skins folder not found at '$rainmeterFolder'. Skipping Rainmeter skin copy."
}