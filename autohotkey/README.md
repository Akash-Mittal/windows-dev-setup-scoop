# AutoHotkey Scripts

This folder contains AutoHotkey scripts for automating various tasks.

## VPN Login (`vpn-login.ahk`)

The `vpn-login.ahk` script automates the process of logging into the Cisco Secure Client VPN.

### Prerequisites

*   [AutoHotkey v2.0](https://www.autohotkey.com/) must be installed.
*   The Cisco Secure Client must be installed in its default location (`C:\Program Files (x86)\Cisco\Cisco Secure Client`).
*   An environment variable named `MITTALA_WINDOWS_PASSWORD` must be set to your Windows password.

> **Security Warning:** Storing your password in an environment variable can be a security risk. Ensure your system is secure and use this feature at your own discretion.

### How it Works (`vpn-login.ahk`)

The script performs the following actions:

1.  Retrieves your password from the `MITTALA_WINDOWS_PASSWORD` environment variable.
2.  Closes any existing instances of the Cisco Secure Client.
3.  Launches the Cisco Secure Client.
4.  Waits for the password window to appear and enters your password.
5.  Waits for the "Accept" window to appear and clicks "Accept".

## Start VPN Login Script (`start-vpn-login.ps1`)

This PowerShell script is designed to launch the `vpn-login.ahk` script using the AutoHotkey executable. It handles checking for the existence of both the AutoHotkey executable and the `.ahk` script before attempting to run.

### How to run

There are two primary ways to run the VPN login automation:

1.  **Via `fire.ps1` (Recommended for Startup)**:
    The `fire.ps1` script (located in the repository root) is configured to call `start-vpn-login.ps1` as part of its startup sequence. This is the intended way for automated execution.

2.  **Directly running `start-vpn-login.ps1`**:
    Open a PowerShell terminal, navigate to this `autohotkey` directory, and execute:
    ```powershell
    .\start-vpn-login.ps1
    ```

3.  **Directly running `vpn-login.ahk`**:
    You can also run the `vpn-login.ahk` script directly by double-clicking the file in File Explorer.
    *   The script will automatically attempt to log in to the VPN 5 seconds after it starts.
    *   You can also trigger the login manually by pressing `Ctrl+Alt+C`.
