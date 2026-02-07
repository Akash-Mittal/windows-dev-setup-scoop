# Windows Dev Setup

This repository contains a collection of scripts and configuration files to automate the setup of a development environment on Windows.

## Overview

The repository is organized into folders, each containing scripts or configuration files for a specific tool or purpose. The `fire.ps1` script at the root of the repository is the main script that orchestrates the setup process.

## `fire.ps1`

The `fire.ps1` script is the main entry point for setting up the development environment. It performs the following tasks:

*   Runs the `windows-dev-env-setup-with-scoop.ps1` script to install a wide range of development tools and applications using Scoop and winget.
*   Directly starts various applications and scripts, including:
    *   Rainmeter
    *   IntelliJ IDEA Ultimate
    *   Notepad++
    *   Docker Desktop
    *   NoSleep
    *   `clear-cache.ps1`
    *   `start-docker-compose.ps1`
    *   `gitupdateandbuild.ps1`
    *   `scoop.update.ps1`
    *   `chrome-open-profiles.ps1`
    *   `vpn-login.ahk`
*   Copies the Rainmeter skins to the appropriate directory.
*   **Processes GitHub Repositories**: If the `GIT_REPO_HOME` environment variable is set and points to a valid directory, the script iterates through each sub-directory (assumed to be a Git repository) and executes `gitupdateandbuild.ps1` within each repository's context.

### How to run

To run the `fire.ps1` script, open a PowerShell terminal, navigate to the root of this repository, and execute:

```powershell
.\fire.ps1
```

**Note:** You may need to set the execution policy to `RemoteSigned` to run the script. You can do this by running the following command in a PowerShell terminal with administrator privileges:

```powershell
Set-ExecutionPolicy RemoteSigned
```

## Folders

*   [**autohotkey**](./autohotkey/README.md): Contains an AutoHotkey script to automate logging into the Cisco Secure Client VPN.

*   [**chrome**](./chrome/README.md): Contains batch scripts for launching Google Chrome with different user profiles and a predefined set of tabs.

*   [**clear-cache**](./clear-cache/README.md): Contains a batch script to clear temporary files from your system.

*   [**docker**](./docker/README.md): Contains Docker Compose files and scripts to set up a local development environment with MongoDB and ActiveMQ.

*   [**github**](./github/README.md): Contains a batch script to automate the process of updating a Git repository and building the project with Maven.

*   [**intellij**](./intellij/README.md): Contains IntelliJ IDEA configuration files, including code style, inspection profiles, and Detekt settings.

*   [**notepad**](./notepad/README.md): Contains a PowerShell script to set Notepad++ as the default application for various file extensions.

*   [**rainmeter**](./rainmeter/README.md): Contains skins for the Rainmeter desktop customization tool, including clocks and a reminder.

*   [**scoop**](./scoop/README.md): Contains a PowerShell script to install a wide range of development tools and applications using Scoop and winget.
