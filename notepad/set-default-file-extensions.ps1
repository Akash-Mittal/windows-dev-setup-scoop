# Makes Notepad++ the default program for the extensions in notepad_config,file_extensions.
# Writes per-user associations (HKCU\Software\Classes), so no administrator rights are needed.
# Windows keeps a default you picked yourself in "Open with" for an extension; change those there.

. (Join-Path $PSScriptRoot "..\lib\common.ps1")

$notepadExe = Expand-ConfigPath (Get-ConfigValue "notepad_config" "notepad_exe" "~\scoop\apps\notepadplusplus\current\notepad++.exe")
if (-not (Test-Path -LiteralPath $notepadExe)) {
    Write-Error "Notepad++ not found at: $notepadExe. Cannot set file associations."
    exit 1
}

$extensions = @((Get-ConfigValue "notepad_config" "file_extensions" "") -split "\s+" |
    Where-Object { $_ -and $_.StartsWith(".") } |
    ForEach-Object { $_.ToLowerInvariant() } |
    Sort-Object -Unique)

if ($extensions.Count -eq 0) {
    Write-Warning "No extensions in notepad_config,file_extensions. Nothing to do."
    exit 0
}

$progId  = "NotepadPP.File"
$classes = "HKCU:\Software\Classes"

# Creates the key only when missing: New-Item -Force on an existing key would wipe its subkeys.
function Set-KeyDefault {
    param([string]$Key, [string]$Value)
    if (-not (Test-Path -LiteralPath $Key)) { New-Item -Path $Key -Force | Out-Null }
    Set-Item -LiteralPath $Key -Value $Value
}

Set-KeyDefault "$classes\$progId" "Notepad++ Document"
Set-KeyDefault "$classes\$progId\DefaultIcon" "`"$notepadExe`",0"
Set-KeyDefault "$classes\$progId\shell\open\command" "`"$notepadExe`" `"%1`""

foreach ($extension in $extensions) {
    Set-KeyDefault "$classes\$extension" $progId
}

# Tell Explorer the associations changed so icons refresh without a restart.
Add-Type -Namespace DevSetup -Name Shell -MemberDefinition @"
[System.Runtime.InteropServices.DllImport("shell32.dll")]
public static extern void SHChangeNotify(int eventId, uint flags, System.IntPtr item1, System.IntPtr item2);
"@
[DevSetup.Shell]::SHChangeNotify(0x08000000, 0, [IntPtr]::Zero, [IntPtr]::Zero)

Write-Host "Associated $($extensions.Count) extensions with Notepad++ ($notepadExe)."
