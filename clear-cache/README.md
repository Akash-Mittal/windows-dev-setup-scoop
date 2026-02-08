# Clear Temporary Files

This PowerShell script clears various temporary files and caches from your user profile.

## `clear-cache.ps1`

The `clear-cache.ps1` script removes temporary files and caches from the following locations:

*   User temporary files (`%TEMP%`)
*   Local AppData temporary files (`%LOCALAPPDATA%\Temp`)
*   Explorer thumbnail cache (`%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*`)
*   Google Chrome browser cache
*   Windows Update download cache (user accessible portion)
*   Recent files and jump lists (`%APPDATA%\Microsoft\Windows\Recent\*`)

After execution, the script will pause and wait for user input before closing the console window.

### How to run

1.  **Via `fire.ps1`**:
    The `fire.ps1` script (located in the repository root) is configured to call `clear-cache.ps1` as part of its startup sequence.

2.  **Manually from PowerShell**:
    Open a PowerShell terminal, navigate to this `clear-cache` directory, and execute:
    ```powershell
    .\clear-cache.ps1
    ```
    The script will run and then prompt you to "Press Enter to exit..." before closing.
