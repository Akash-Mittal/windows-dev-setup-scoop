# Windows Development Environment Setup with Scoop

This folder contains a PowerShell script to automate the setup of a Windows development environment using [Scoop](https://scoop.sh/).

## Script

`windows-dev-env-setup-with-scoop.ps1`: This script installs a comprehensive set of development tools and applications.

### Prerequisites

*   [Scoop](https://scoop.sh/) must be installed. You can install it by running the following command in PowerShell:

    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
    ```

### Usage

1.  Open a PowerShell terminal.
2.  Navigate to this folder.
3.  Run the `windows-dev-env-setup-with-scoop.ps1` script.

### What it Installs

The script will install the following software using Scoop:

**Development Tools:**

*   Git
*   OpenJDK 21
*   Maven
*   Node.js LTS
*   NVM (Node Version Manager)
*   IntelliJ IDEA Ultimate
*   gcloud CLI
*   Yarn
*   MongoDB Database Tools
*   mongosh
*   MongoDB Compass
*   Postman
*   JMeter
*   Insomnia
*   GitHub CLI
*   FileZilla
*   cloudflared
*   Terraform
*   AutoHotkey
*   Kafka
*   TortoiseGit
*   Gradle
*   Scala
*   MySQL
*   kubectl
*   Minikube
*   Visual Studio Code

**Other Applications:**

*   OpenShot Video Editor
*   Google Chrome
*   FFmpeg
*   ChatGPT
*   7-Zip
*   Zoom
*   VLC
*   Rainmeter
*   NoSleep
*   sudo
*   Notepad++

The script also uses `winget` to install:

*   Docker Desktop
*   Google Drive
*   Another application with ID `9NBDXK71NK08`

**Note:** The script will skip any packages that are already installed.
