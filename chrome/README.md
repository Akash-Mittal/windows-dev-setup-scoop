# Google Chrome Profile Management

This directory contains configuration for managing Google Chrome profiles and their associated startup URLs. The primary configuration file is `chrome.json`, which defines various profiles, their respective data directories, and a list of URLs to open when the profile is launched.

## `chrome.json`

The `chrome.json` file is a JSON object where each top-level key represents a distinct Chrome profile. Each profile object has the following properties:

* `profileDirectory`: (String) The name of the directory where Chrome stores the profile data. This is typically found within Chrome's user data directory (e.g., `User Data/Profile 1` or `User Data/Personal`).
* `runOnStartup`: (Object) Contains a list of URLs to be opened in new tabs when the profile is launched.
  * `urls`: (Array of Strings) A list of URLs that Chrome will open upon startup for this profile.

### Example Structure:

```json
{
  "profile_name": {
    "profileDirectory": "Profile Name",
    "runOnStartup": {
      "urls": [
        "https://example.com/page1",
        "https://example.com/page2"
      ]
    }
  }
}
```

## Configured Profiles

Based on the `chrome.json` file, the following profiles are configured:

* **`personal`**: Configured for personal browsing, including Google Calendar, Mail (u/0 and u/1), Translate, Maps, and Idealista alerts.
* **`professional`**: Configured for work-related browsing, including Confluence, Jira, Google Cloud Console, GitHub, MongoDB Atlas, and a specific frontend application.
* **`blogging`**: Configured for blogging activities, including Bluehost, cPanel, and WordPress sites.
* **`banking`**: Configured for online banking, including HDFC, ICICI, Commerzbank, Deutsche Bank, Santander, N26, and Revolut.

## Usage

This configuration is intended to be used by scripts (e.g., PowerShell or batch scripts) to automate the launching of Chrome with specific profiles and pre-defined tabs.

A typical script would:

1. Read the `chrome.json` file.
2. Identify the desired profile (e.g., "personal").
3. Construct the Chrome launch command using the `profileDirectory` and the `urls`.

### Example Command (Conceptual PowerShell):

```powershell
# Assuming $chromePath is the path to chrome.exe (e.g., "C:\Program Files\Google\Chrome\Application\chrome.exe")
# Assuming $profileData contains the parsed JSON for a specific profile (e.g., $chromeConfig.profiles.personal)

$profileDir = $profileData.profileDirectory
$urls = $profileData.runOnStartup.urls -join ' ' # Join URLs with spaces for command line

Start-Process -FilePath "$chromePath" -ArgumentList "--profile-directory=`"$profileDir`"", $urls
```

This setup allows for quick and consistent launching of Chrome with different contexts, reducing manual tab opening and improving workflow efficiency.

### How to run

To run the `chrome-open-profiles.ps1` script, open a PowerShell terminal, navigate to this directory, and execute:

```powershell
.\chrome-open-profiles.ps1
```
