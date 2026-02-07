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
  }
}
```

## `chrome-open-profiles.ps1`

The `chrome-open-profiles.ps1` script reads the `chrome.json` file and launches Chrome with the configured profiles and URLs.

### How to run

To run the `chrome-open-profiles.ps1` script, open a PowerShell terminal, navigate to this directory, and execute:

```powershell
.\chrome-open-profiles.ps1
```
