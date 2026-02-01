# Git Update and Build

This script automates the process of updating a Git repository and building the project using Maven.

## Usage

1.  Run the `gitupdateandbuild.bat` script.
2.  The script will:
    *   Fetch the latest updates from the remote repository.
    *   Pull the latest changes into your local branch.
    *   Run `mvn clean install -Denv=release` to build the project.
