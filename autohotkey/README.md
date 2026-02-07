# AutoHotkey Scripts

This folder contains AutoHotkey scripts for automating various tasks.

## VPN Login (`vpn-login.ahk`)

The `vpn-login.ahk` script automates the process of logging into the Cisco Secure Client VPN.

### Prerequisites

*   [AutoHotkey v2.0](https://www.autohotkey.com/) must be installed.
*   The Cisco Secure Client must be installed in its default location (`C:\Program Files (x86)\Cisco\Cisco Secure Client`).
*   An environment variable named `MITTALA_WINDOWS_PASSWORD` must be set to your Windows password.

> **Security Warning:** Storing your password in an environment variable can be a security risk. Ensure your system is secure and use this feature at your own discretion.

### Usage

1.  Make sure the prerequisites are met.
2.  Run the `vpn-login.ahk` script by double-clicking the file.
3.  The script will automatically attempt to log in to the VPN 5 seconds after it starts.
4.  You can also trigger the login manually by pressing `Ctrl+Alt+C`.

### How it Works

The script performs the following actions:

1.  Retrieves your password from the `MITTALA_WINDOWS_PASSWORD` environment variable.
2.  Closes any existing instances of the Cisco Secure Client.
3.  Launches the Cisco Secure Client.
4.  Waits for the password window to appear and enters your password.
5.  Waits for the "Accept" window to appear and clicks "Accept".
