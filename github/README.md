# Git Update and Build

This PowerShell script automates the process of updating multiple Git repositories and building their respective projects. It reads its configuration from the `github.json` file, allowing for dynamic and repository-specific build commands.

## `github.json`

The `github.json` file contains a list of repositories and their corresponding build commands.

*   Each entry in the `repos` array should be an object with:
    *   `path`: The absolute path to the Git repository.
    *   `buildCommand`: The command to execute for building the project (e.g., `mvn clean install`, `npm install && npm run build`).

### Example `github.json`:

```json
{
  "github": {
    "repos": [
      {
        "path": "C:\\Users\\mittala\\github\\work\\my-java-project",
        "buildCommand": "mvn clean install -Denv=release"
      },
      {
        "path": "C:\\Users\\mittala\\github\\work\\my-js-project",
        "buildCommand": "npm install && npm run build"
      }
    ]
  }
}
```

## `gitupdateandbuild.ps1`

The `gitupdateandbuild.ps1` script reads the `github.json` file and performs the following actions for each repository:

*   Navigates to the repository directory.
*   Executes `git fetch` to get the latest updates from the remote.
*   Executes `git pull` to integrate those changes into the local branch.
*   Executes the `buildCommand` specified in `github.json` to build the project.

### How to run

To run the `gitupdateandbuild.ps1` script, open a PowerShell terminal, navigate to this directory, and execute:

```powershell
.\gitupdateandbuild.ps1
```
