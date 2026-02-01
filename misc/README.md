# Miscellaneous Scripts

This folder contains miscellaneous utility scripts.

## Set Default File Extensions for Notepad++

The `defualt-file-extension.notepad.ps1` script sets Notepad++ as the default application for a wide variety of file extensions, primarily those used in development.

### Prerequisites

*   Notepad++ must be installed via Scoop to the default location (`$env:USERPROFILE\scoop\apps\notepadplusplus\current\notepad++.exe`).
*   The script must be run with administrator privileges.

### Usage

1.  Open a PowerShell terminal with administrator privileges.
2.  Navigate to this folder.
3.  Run the `defualt-file-extension.notepad.ps1` script.

### How it Works

The script iterates through a predefined list of file extensions and uses the `assoc` and `ftype` commands to associate them with Notepad++.
