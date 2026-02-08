$ErrorActionPreference = "SilentlyContinue"

$notepadJsonPath = Join-Path $PSScriptRoot "notepad.json"
if (!(Test-Path $notepadJsonPath)) {
    Write-Warning "notepad.json not found at '$notepadJsonPath'. Skipping opening Notepad++ files."
    exit 0
}

try {
    $notepadConfig = Get-Content -Path $notepadJsonPath -Raw | ConvertFrom-Json
} catch {
    Write-Error "Failed to parse notepad.json. $($_.Exception.Message)"
    exit 1
}

$notepadExePath = Join-Path $env:USERPROFILE "scoop\apps\notepadplusplus\current\notepad++.exe"

if (!(Test-Path $notepadExePath)) {
    Write-Warning "Notepad++ executable not found at '$notepadExePath'. Cannot open files."
    exit 1
}

if ($notepadConfig.openFiles) {
    foreach ($filePath in $notepadConfig.openFiles) {
        if (Test-Path $filePath) {
            Write-Host "Opening file: $filePath"
            Start-Process -FilePath $notepadExePath -ArgumentList "`"$filePath`"" -NoNewWindow
        } else {
            Write-Warning "File not found: $filePath. Skipping."
        }
    }
} else {
    Write-Host "No files specified in notepad.json to open."
}