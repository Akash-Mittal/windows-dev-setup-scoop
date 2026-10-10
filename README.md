# Windows Dev Setup

This repository contains a collection of scripts and configuration files to automate the setup of a development environment on Windows.

## Overview

The repository is organized into folders, each containing scripts or configuration files for a specific tool or purpose. The `fire.sh` script at the root of the repository is the main script that orchestrates the setup process.

## `fire.sh`

The `fire.sh` script (Bash, run from Git Bash) is the main entry point for setting up the development environment. It performs the following tasks:

*   Changes the working directory to the script's location so relative paths and Git commands work.
*   Reads `windows_dev_setup.csv` and, if `installonstartup` in the `install-configs` worksheet is `true` (the default when the file or row is missing), runs `scoop/start-scoop-windows-setup.ps1`.
*   Configures Git with `core.longpaths true` globally and locally, then runs `composer update` and installs the Laravel installer.
*   Starts the startup items (missing ones are skipped with a warning): AutoHotkey VPN login, Docker Desktop, Chrome profiles, Rainmeter, IntelliJ IDEA Ultimate, Notepad++ and its default files, NoSleep, clear cache, Docker Compose, MongoDB Compass, Scoop update, and `github/start-git-update-build.sh`.

### `windows_dev_setup.csv`

A flat CSV whose `worksheet` column groups settings, so it can hold several "sheets" in one file:

```csv
worksheet,config,value
install-configs,installonstartup,true
```

Set `value` to `false` to skip the Scoop install step.

### How to run

1.  **From Git Bash**, in the repository root:
    ```bash
    ./fire.sh                       # uses windows_dev_setup.csv next to the script
    ./fire.sh path/to/other.csv     # optional: a different config file
    ```

2.  **Using a Batch File (e.g., for Startup)**:
    ```batch
    @echo off
    "C:\Program Files\Git\bin\bash.exe" -l "C:\Users\Lenovo\github\personal\windows-dev-setup-scoop\fire.sh"
    ```

**Note on Execution Policy:** `fire.sh` launches the PowerShell scripts with `-ExecutionPolicy Bypass`, so no policy change is needed for them.

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
