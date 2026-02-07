# Clear Temporary Files

This PowerShell script clears the user and Windows temporary file folders.

## `clear-cache.ps1`

The `clear-cache.ps1` script removes temporary files from the following locations:

*   `%TEMP%`
*   `C:\Windows\Temp`

**Note:** This script requires administrator privileges to clear temporary files from `C:\Windows\Temp`. The script will attempt to elevate itself if not already running as administrator.

### How to run

To run the `clear-cache.ps1` script, open a PowerShell terminal (preferably as administrator), navigate to this directory, and execute:

```powershell
.\clear-cache.ps1
```
