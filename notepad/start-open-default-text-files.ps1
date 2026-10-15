# Starts Notepad++ with the files in notepad_config,open_file rows (missing files are skipped).

. (Join-Path $PSScriptRoot "..\lib\common.ps1")

$notepadExe = Expand-ConfigPath (Get-ConfigValue "notepad_config" "notepad_exe" "~\scoop\apps\notepadplusplus\current\notepad++.exe")
if (-not (Test-Path -LiteralPath $notepadExe)) {
    Write-Warning "Notepad++ not found at '$notepadExe'."
    exit 1
}

$files = @()
foreach ($file in Get-ConfigValues "notepad_config" "open_file") {
    $path = Expand-ConfigPath $file
    if (Test-Path -LiteralPath $path) {
        $files += "`"$path`""
    } else {
        Write-Warning "File not found, skipping: $path"
    }
}

if ($files.Count -gt 0) {
    Write-Host "Opening $($files.Count) file(s) in Notepad++"
    Start-Process -FilePath $notepadExe -ArgumentList ($files -join " ")
} else {
    Start-Process -FilePath $notepadExe
}
