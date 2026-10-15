# Clear cache

`start-clear-cache.ps1` deletes files from:

* `%TEMP%`
* `%LOCALAPPDATA%\Temp`
* Chrome's default profile `Cache` and `Code Cache`

Files in use are skipped. It runs at login (`startup_apps`, "Clear cache"), without prompting.

```powershell
.\start-clear-cache.ps1
```
