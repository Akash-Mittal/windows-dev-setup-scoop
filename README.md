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
    *   ChatGPT
    *   NoSleep
    *   Google Drive
    *   `clear-cache.bat`
    *   `start-docker-compose.bat`
    *   `gitupdateandbuild.bat`
    *   `sccop.update.ps1`
*   Copies the Rainmeter skins to the appropriate directory.
*   Starts all Chrome startup scripts.
*   **Processes GitHub Repositories**: If the `GIT_REPO_HOME` environment variable is set and points to a valid directory, the script iterates through each sub-directory (assumed to be a Git repository) and executes `gitupdateandbuild.bat` within each repository's context.

## Folders

*   [**autohotkey**](./autohotkey/README.md): Contains an AutoHotkey script to automate logging into the Cisco Secure Client VPN.

*   [**chrome**](./chrome/README.md): Contains batch scripts for launching Google Chrome with different user profiles and a predefined set of tabs.

*   [**clear-cache**](./clear-cache/README.md): Contains a batch script to clear temporary files from your system.

*   [**docker**](./docker/README.md): Contains Docker Compose files and scripts to set up a local development environment with MongoDB and ActiveMQ.

*   [**github**](./github/README.md): Contains a batch script to automate the process of updating a Git repository and building the project with Maven.

*   [**intellij**](./intellij/README.md): Contains IntelliJ IDEA configuration files, including code style, inspection profiles, and Detekt settings.

*   [**misc**](notepad/README.md): Contains a PowerShell script to set Notepad++ as the default application for various file extensions.

*   [**rainmeter**](./rainmeter/README.md): Contains skins for the Rainmeter desktop customization tool, including clocks and a reminder.

*   [**scoop**](./scoop/README.md): Contains a PowerShell script to install a wide range of development tools and applications using Scoop and winget.
