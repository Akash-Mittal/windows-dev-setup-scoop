# Chrome profiles

`start-chrome.ps1` opens one Chrome window per profile, with that profile's URLs.
It runs at login (`startup_apps`, "Chrome").

## Settings (worksheet `chrome_config`)

| config | value |
|---|---|
| `chrome_exe` | Optional path to `chrome.exe`. Otherwise Scoop, Program Files and LocalAppData are searched |
| `delay_ms` | Pause between windows (default `150`) |
| `startup_profiles` | Space-separated profiles to open at login. Empty means all |
| `<profile>.profile_directory` | Chrome's profile folder name (e.g. `Default`, `Profile 1`) |
| `<profile>.url` | One row per URL to open |

```csv
chrome_config,startup_profiles,personal work,,
chrome_config,work.profile_directory,work,,
chrome_config,work.url,https://github.com,,
```

## Run by hand

```powershell
.\start-chrome.ps1               # startup_profiles, or every profile
.\start-chrome.ps1 finance blog  # specific profiles
```
