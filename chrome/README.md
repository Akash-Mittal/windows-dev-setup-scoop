# Google Chrome Profile Management

This directory contains configuration for managing Google Chrome profiles and their associated startup URLs. The primary configuration file is `chrome.json`, which defines various profiles, their respective data directories, and a list of URLs to open when the profile is launched.

## `chrome.json`

The `chrome.json` file is a JSON object where each top-level key represents a distinct Chrome profile. Each profile object has the following properties:

*   `profileDirectory`: The name of the directory where Chrome stores the profile data (e.g., `Profile 1` or `Personal`).
*   `runOnStartup`: An object containing a list of URLs to be opened in new tabs when the profile is launched.
    *   `urls`: An array of URLs that Chrome will open upon startup for this profile.

### Example `chrome.json`:

```json
{
  "personal": {
    "profileDirectory": "Profile 1",
    "runOnStartup": {
      "urls": [
        "https://www.google.com",
        "https://www.github.com"
      ]
    }
  },
  "work": {
    "profileDirectory": "Profile 2",
    "runOnStartup": {
      "urls": [
        "https://www.jira.com",
        "https://www.confluence.com"
      ]
    }
  }
}
```

## `chrome-open-profiles.ps1`

The `chrome-open-profiles.ps1` script reads the `chrome.json` file and launches Chrome with the configured profiles and URLs. It can be run with specific profile names as arguments to open only those profiles.

### How to run

1.  **Via `fire.ps1`**:
    The `fire.ps1` script (located in the repository root) is configured to call `chrome-open-profiles.ps1` with specific profile names (e.g., `personal work`) as part of its startup sequence.

2.  **Manually from PowerShell**:
    Open a PowerShell terminal, navigate to this `chrome` directory, and execute:

    *   **To open all configured profiles**:
        ```powershell
        .\chrome-open-profiles.ps1
        ```

    *   **To open specific profiles (e.g., "personal" and "work")**:
        ```powershell
        .\chrome-open-profiles.ps1 personal work
        ```
        Replace `personal work` with the names of the profiles you wish to open, as defined in `chrome.json`.
