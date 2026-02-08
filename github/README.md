# Git Update and Build

This PowerShell script automates the process of updating a single Git repository and building its project. It is designed to be run from within a Git repository's directory.

## `github.json`

The `github.json` file contains a list of repositories and their corresponding build commands. This file is primarily used by the `fire.ps1` script to determine which repositories to process and how to build them.

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

The `gitupdateandbuild.ps1` script performs the following actions:

*   Executes `git fetch` to get the latest updates from the remote.
*   Executes `git pull` to integrate those changes into the local branch.
*   If a `buildCommand` is provided (e.g., via `fire.ps1` or directly as an argument), it executes that command to build the project.

### How to run

1.  **Via `fire.ps1` (Automated Processing)**:
    The `fire.ps1` script (located in the repository root) is designed to iterate through subdirectories of a configured `GIT_REPO_HOME` environment variable. For each subdirectory (assumed to be a Git repository), `fire.ps1` will change into that directory and then call `gitupdateandbuild.ps1` within that context, passing the appropriate `buildCommand` from `github.json`.

2.  **Manually from PowerShell (within a Git repository)**:
    To run this script manually for a specific repository, first navigate to the root of that Git repository in a PowerShell terminal. Then, you can execute `gitupdateandbuild.ps1` with an optional build command:

    *   **To only fetch and pull (no build)**:
        ```powershell
        & "C:\Users\Lenovo\github\personal\windows-dev-setup-scoop\github\gitupdateandbuild.ps1"
        ```
        (Note: You need to provide the full path to the script if you are not in its directory)

    *   **To fetch, pull, and execute a build command**:
        ```powershell
        & "C:\Users\Lenovo\github\personal\windows-dev-setup-scoop\github\gitupdateandbuild.ps1" -BuildCommand "mvn clean install"
        ```
        Replace `"mvn clean install"` with your desired build command.
