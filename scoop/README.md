# Scoop

Software installation now lives in `setup.ps1` at the repo root. The package list is in
`windows_dev_setup.csv` (worksheets `scoop_buckets`, `scoop_packages`, `winget_packages`, `post_install`).
To add or remove software, add a row or set `enabled` to `false`.

## `start-scoop-update.ps1`

Updates Scoop and every installed app, then cleans up old versions.
`startup.ps1` runs it every `startup_settings,scoop_update_every_days` days (default 7; `0` turns it off).
The last run time is kept in `.state\last-scoop-update.txt`.

Run it by hand any time:

```powershell
.\start-scoop-update.ps1
```
