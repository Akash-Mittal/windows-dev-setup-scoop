#Requires AutoHotkey v2.0
#SingleInstance Force

VPN_EXE      := "C:\Program Files (x86)\Cisco\Cisco Secure Client\UI\csc_ui.exe"
VPN_PROC     := "csc_ui.exe"
PWD_TITLE    := "Cisco Secure Client | MediaMarktSaturn 2"
ACCEPT_TITLE := "Cisco Secure Client"

PWD_X := 120
PWD_Y := 76

RunVpnFlow(*) {
    password := EnvGet("WINDOWS_PASSWORD")
    if (password = "")
        return

    if ProcessExist(VPN_PROC) {
        try ProcessClose(VPN_PROC)
        Sleep 400
    }

    if FileExist(VPN_EXE)
        Run('"' VPN_EXE '"')

    hwndPwd := WinWait(PWD_TITLE, , 20)
    if !hwndPwd
        return

    WinActivate("ahk_id " hwndPwd)
    Sleep 300

    CoordMode("Mouse", "Client")
    Click PWD_X, PWD_Y
    Sleep 150

    Send("^a")
    Sleep 80
    SendText(password)
    Sleep 120
    Send("{Enter}")

    if !WaitForAcceptWindow(20000)
        return

    try WinActivate(ACCEPT_TITLE)
    Sleep 200
    Send("{Enter}")
}

WaitForAcceptWindow(timeoutMs) {
    start := A_TickCount
    while (A_TickCount - start) < timeoutMs {
        for hwnd in WinGetList() {
            try {
                t := WinGetTitle("ahk_id " hwnd)
                if InStr(t, ACCEPT_TITLE) && !InStr(t, PWD_TITLE)
                    return true
            } catch {
            }
        }
        Sleep 150
    }
    return false
}

; auto-run 5 seconds after script start
SetTimer(RunVpnFlow, -5000)

; optional manual trigger
^!c:: RunVpnFlow()
