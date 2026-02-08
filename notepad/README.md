# Notepad++ Management

This folder contains PowerShell scripts and configuration for managing Notepad++ file associations and automatically opening specific text files.

## `default-file-extension.notepad.ps1`

The `default-file-extension.notepad.ps1` script automates the process of associating a predefined list of file extensions with Notepad++. This ensures that when you open files with these extensions, they will automatically launch in Notepad++.

### Prerequisites

*   **Notepad++ Installation**: Notepad++ must be installed, preferably via Scoop, to its default location (e.g., `$env:USERPROFILE\scoop\apps\notepadplusplus\current\notepad++.exe`). The script relies on this path to correctly set the file associations.

### How it Works (`default-file-extension.notepad.ps1`)

The script iterates through a comprehensive list of file extensions. For each extension, it uses Windows' built-in `assoc` and `ftype` commands to:
1.  Create or update a file type association (e.g., `.txt` becomes `txtfile`).
2.  Define the command that opens files of that type (e.g., `txtfile` opens with `notepad++.exe`).

### How to run (`default-file-extension.notepad.ps1`)

**Important**: This script modifies system-wide file associations and **must be run with administrator privileges**.

1.  **Open PowerShell as Administrator**:
    *   Right-click on the PowerShell icon in the Start Menu or Taskbar.
    *   Select "Run as administrator".

2.  **Navigate to this directory**:
    ```powershell
    cd "C:\Users\Lenovo\github\personal\windows-dev-setup-scoop\notepad"
    ```
    (Adjust the path if your repository is located elsewhere).

3.  **Execute the script**:
    ```powershell
    .\default-file-extension.notepad.ps1
    ```
    The script will run and apply the file associations. There is no interactive prompt after execution.

## `notepad.json`

This JSON file specifies a list of text files that `open.text.files.ps1` should automatically open in Notepad++.

### Structure

The `notepad.json` file should contain a single JSON object with an `openFiles` array. Each element in the `openFiles` array should be a string representing the absolute path to a text file.

### Example `notepad.json`:

```json
{
    "openFiles": [
        "G:\\Other computers\\My Laptop\\Google-Drive\\DOCUMENTS\\Online\\DAP.txt",
        "G:\\Other computers\\My Laptop\\Google-Drive\\DOCUMENTS\\Online\\time-line.txt"
    ]
}
```

## `open.text.files.ps1`

This PowerShell script reads the `notepad.json` file and opens each specified file in Notepad++. It ensures that Notepad++ is installed and that each file exists before attempting to open it.

### How to run (`open.text.files.ps1`)

1.  **Via `fire.ps1`**:
    The `fire.ps1` script (located in the repository root) is configured to call `open.text.files.ps1` as part of its startup sequence, automatically opening your predefined list of files.

2.  **Manually from PowerShell**:
    Open a PowerShell terminal, navigate to this `notepad` directory, and execute:
    ```powershell
    .\open.text.files.ps1
    ```
    The script will attempt to open all files listed in `notepad.json`. Warnings will be displayed for any files that are not found.
