# Windows Dev Setup

This repository contains a collection of scripts and configuration files to automate the setup of a development environment on Windows.

## Overview

The repository is organized into folders, each containing scripts or configuration files for a specific tool or purpose. The `fire.ps1` script at the root of the repository is the main script that orchestrates the setup process.

## `fire.ps1`

The `fire.ps1` script is the main entry point for setting up the development environment. It performs the following tasks:

*   Sets the current working directory to the script's location (`$PSScriptRoot`) to ensure relative paths and Git commands function correctly.
*   Configures Git with `core.longpaths true` globally and locally.
*   Runs the `windows-dev-env-setup-with-scoop.ps1` script to install a wide range of development tools and applications using Scoop and winget (if `installonstartup` is true in `fire.json`).
*   Directly starts various applications and scripts, including:
    *   Rainmeter
    *   IntelliJ IDEA Ultimate
    *   Notepad++
    *   Docker Desktop
    *   NoSleep
    *   `autohotkey\start-vpn-login.ps1` (which then launches `vpn-login.ahk`)
    *   `clear-cache.ps1`
    *   `start-docker-compose.ps1`
    *   `gitupdateandbuild.ps1`
    *   `scoop.update.ps1`
    *   `chrome-open-profiles.ps1`
    *   MongoDB Compass
*   Copies the Rainmeter skins to the appropriate directory.
*   **Processes GitHub Repositories**: If the `GIT_REPO_HOME` environment variable is set and points to a valid directory, the script iterates through each sub-directory (assumed to be a Git repository) and executes `gitupdateandbuild.ps1` within each repository's context.

### How to run

To run the `fire.ps1` script, you have a few options:

1.  **Manually from PowerShell**:
    Open a PowerShell terminal, navigate to the root of this repository, and execute:
    ```powershell
    .\fire.ps1
    ```

2.  **Using a Batch File (e.g., for Startup)**:
    Create a `.bat` file (e.g., `run_fire.bat`) with the following content. This is useful if you want to run it from the Windows Startup folder or as a scheduled task.
    ```batch
    @echo off
    REM Change directory to the location of this batch file (if fire.ps1 is in the same folder)
    REM If fire.ps1 is in a fixed path, you can remove 'cd /d "%~dp0"' and use the full path directly.
    cd /d "%~dp0"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Lenovo\github\personal\windows-dev-setup-scoop\fire.ps1"
    pause
    ```
    *Note*: If the `.bat` file is in the same directory as `fire.ps1`, you can simplify the `powershell.exe` line to `-File "fire.ps1"`. If the `.bat` file is in a different location (like the Startup folder), use the full path as shown above.

**Note on Execution Policy:** You may need to set the execution policy to `RemoteSigned` to run PowerShell scripts. You can do this by running the following command in a PowerShell terminal with administrator privileges:

```powershell
Set-ExecutionPolicy RemoteSigned
```

## Folders

*   [**autohotkey**](./autohotkey/README.md): Contains an AutoHotkey script to automate logging into the Cisco Secure Client VPN.

*   [**chrome**](./chrome/README.md): Contains batch scripts for launching Google Chrome with different user profiles and a predefined set of tabs.

*   [**clear-cache**](./clear-cache/README.md): Contains a PowerShell script to clear temporary files from your system.

*   [**docker**](./docker/README.md): Contains Docker Compose files and scripts to set up a local development environment with MongoDB and ActiveMQ.

*   [**github**](./github/README.md): Contains a PowerShell script to automate the process of updating a Git repository and building the project with Maven.

*   [**intellij**](./intellij/README.md): Contains IntelliJ IDEA configuration files, including code style, inspection profiles, and Detekt settings.

*   [**notepad**](./notepad/README.md): Contains a PowerShell script to set Notepad++ as the default application for various file extensions.

*   [**rainmeter**](./rainmeter/README.md): Contains skins for the Rainmeter desktop customization tool, including clocks and a reminder.

*   [**scoop**](./scoop/README.md): Contains a PowerShell script to install a wide range of development tools and applications using Scoop and winget.
