# AutoHotkey: VPN login

`vpn-login.ahk` logs into the Cisco Secure Client VPN. It runs at login (`startup_apps`, "VPN login")
with the AutoHotkey v2 executable from `startup_settings,autohotkey_exe`.

## Prerequisites

* AutoHotkey v2 (installed by `setup.ps1` through Scoop).
* Cisco Secure Client in its default location (`C:\Program Files (x86)\Cisco\Cisco Secure Client`).
* A user environment variable `WINDOWS_PASSWORD` holding the password to type. The password is never stored in this repo.

> **Security warning:** an environment variable is readable by any program running as you. Use this at your own discretion.

## What it does

1. Reads the password from `WINDOWS_PASSWORD` (does nothing if it is empty).
2. Closes any running Cisco Secure Client, then starts it.
3. Waits for the password window and enters the password.
4. Waits for the "Accept" window and accepts.

Trigger it again any time with `Ctrl+Alt+C`.
