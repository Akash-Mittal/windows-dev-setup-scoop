# Windows Development Environment Setup with Scoop

This folder contains PowerShell scripts to automate the setup and maintenance of a Windows development environment using [Scoop](https://scoop.sh/).

## Scripts

*   `windows-dev-env-setup-with-scoop.ps1`: Installs a comprehensive set of development tools and applications.
*   `scoop.update.ps1`: Updates all installed Scoop packages.

### Prerequisites

*   [Scoop](https://scoop.sh/) must be installed. You can install it by running the following command in PowerShell:

    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
    ```

### How to run

To run the scripts, open a PowerShell terminal, navigate to this directory, and execute the desired script:

```powershell
# To set up the environment
.\windows-dev-env-setup-with-scoop.ps1

# To update installed packages
.\scoop.update.ps1
```

### What `windows-dev-env-setup-with-scoop.ps1` Installs

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
