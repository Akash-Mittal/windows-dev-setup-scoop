# Windows Development Environment Setup with Scoop

This folder contains PowerShell scripts to automate the setup and maintenance of a Windows development environment primarily using [Scoop](https://scoop.sh/) and `winget`.

## Scripts

*   `windows-dev-env-setup-with-scoop.ps1`: This script orchestrates the installation of a comprehensive set of development tools and applications using Scoop and `winget`. It's designed to set up a new machine or refresh an existing one with all the necessary software.
*   `scoop.update.ps1`: This script automates the process of updating all installed Scoop packages to their latest versions, ensuring your tools are always up-to-date.

### Prerequisites

*   **Scoop Installation**: [Scoop](https://scoop.sh/) must be installed on your system. If you don't have it, you can install it by running the following commands in PowerShell:

    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Only if not already set
    irm get.scoop.sh | iex
    ```

### How to run

1.  **Via `fire.ps1` (Recommended for Automation)**:
    *   `windows-dev-env-setup-with-scoop.ps1`: The `fire.ps1` script (located in the repository root) can be configured to call this setup script automatically if `installonstartup` is set to `true` in `fire.json`.
    *   `scoop.update.ps1`: The `fire.ps1` script is configured to call `scoop.update.ps1` as part of its startup sequence to keep your Scoop applications updated.

2.  **Manually from PowerShell**:
    Open a PowerShell terminal, navigate to this `scoop` directory, and execute the desired script:

    *   **To set up the environment (install/update tools)**:
        ```powershell
        .\windows-dev-env-setup-with-scoop.ps1
        ```

    *   **To update all installed Scoop packages**:
        ```powershell
        .\scoop.update.ps1
        ```

### What `windows-dev-env-setup-with-scoop.ps1` Installs

The script will install the following software using Scoop and `winget`:

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

**Note:** The script will skip any packages that are already installed, making it safe to run multiple times.
