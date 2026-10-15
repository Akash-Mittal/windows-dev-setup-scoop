# Notepad++

## `set-default-file-extensions.ps1`

Makes Notepad++ the default program for the extensions in `notepad_config,file_extensions`
(space-separated). Runs from `setup.ps1`.

It writes per-user associations (`HKCU\Software\Classes`), so no administrator rights are needed.
Windows keeps any default you picked yourself through "Open with"; change those there.

## `start-open-default-text-files.ps1`

Starts Notepad++ with the files in `notepad_config,open_file` rows (one row per file; missing files are skipped).
Runs at login (`startup_apps`, "Notepad++ files").

## Settings (worksheet `notepad_config`)

| config | value |
|---|---|
| `notepad_exe` | Path to `notepad++.exe` (default: the Scoop install) |
| `file_extensions` | Extensions to associate, e.g. `.txt .log .md` |
| `open_file` | A file to open at login (repeat the row for more) |
