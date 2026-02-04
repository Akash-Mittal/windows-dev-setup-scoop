# Git Update and Build

This PowerShell script automates the process of updating multiple Git repositories and building their respective projects. It reads its configuration from the `github.json` file, allowing for dynamic and repository-specific build commands.

## Usage

1.  **Configure `github.json`**: Ensure that the `github.json` file is correctly configured with the paths to your Git repositories and their corresponding build commands.
    *   Each entry in the `repos` array should be an object with:
        *   `path`: The absolute path to the Git repository.
        *   `buildCommand`: The command to execute for building the project (e.g., `mvn clean install`, `npm install && npm run build`).

    **Example `github.json` structure:**
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

2.  **Run the `gitupdateandbuild.ps1` script.**

The script will then:
*   Read the list of repositories and their build commands from `github.json`.
*   For each configured repository:
    *   Navigate to the repository directory.
    *   Execute `git fetch` to get the latest updates from the remote.
    *   Execute `git pull` to integrate those changes into the local branch.
    *   Execute the `buildCommand` specified in `github.json` to build the project.

### How to run

To run the `gitupdateandbuild.ps1` script, open a PowerShell terminal, navigate to this directory, and execute:

```powershell
.\gitupdateandbuild.ps1
```
