# Notepad++ Default File Associations

This PowerShell script sets Notepad++ as the default application for a wide variety of file extensions, primarily those used in development.

## `default-file-extension.notepad.ps1`

The `default-file-extension.notepad.ps1` script sets Notepad++ as the default application for a predefined list of file extensions.

### Prerequisites

*   Notepad++ must be installed via Scoop to the default location (`$env:USERPROFILE\scoop\apps\notepadplusplus\current\notepad++.exe`).
*   The script must be run with administrator privileges.

### How to run

1.  Open a PowerShell terminal with administrator privileges.
2.  Navigate to this directory.
3.  Execute the script:

```powershell
.\default-file-extension.notepad.ps1
```

### How it Works

The script iterates through a predefined list of file extensions and uses the `assoc` and `ftype` commands to associate them with Notepad++.
