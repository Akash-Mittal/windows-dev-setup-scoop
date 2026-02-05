Set-Location $PSScriptRoot

$autohotkeyExe = Join-Path $env:USERPROFILE "scoop\apps\autohotkey\current\v2\AutoHotkey64.exe"
$vpnLoginAhk = Join-Path $PSScriptRoot "vpn-login.ahk"

if (Test-Path $autohotkeyExe) {
    if (Test-Path $vpnLoginAhk) {
        Start-Process -FilePath $autohotkeyExe -ArgumentList $vpnLoginAhk -NoNewWindow
    } else {
        Write-Warning "vpn-login.ahk not found at '$vpnLoginAhk'. AutoHotkey script not started."
    }
} else {
    Write-Warning "AutoHotkey executable not found at '$autohotkeyExe'. AutoHotkey script not started."
}