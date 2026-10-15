# Windows Dev Setup — MVP1

Sets up a Windows development machine from one CSV file, then starts your daily apps silently at every login.

Two jobs, kept separate:

| | Script | When |
|---|---|---|
| **Setup** | `setup.ps1` | New machine, or after adding software. Installs everything, safe to re-run. |
| **Startup** | `startup.ps1` | Every login, automatically and silently. Starts apps, refreshes and builds repos. |

Everything is PowerShell (Windows PowerShell 5.1, built into Windows), so a fresh machine needs nothing pre-installed.

## One folder for everything

`general,root_dir` in the CSV picks the drive or folder (e.g. `D:`). If it doesn't exist, your user folder `~` is used.
Everything lives in `<root_dir>\windows-dev-setup` (the workspace), which is this repo:

```
D:\windows-dev-setup                      this repo
D:\windows-dev-setup\chrome
D:\windows-dev-setup\rainmeter\trump-skins
D:\windows-dev-setup\github\Akash-Mittal\repo1     cloned repos, one folder per GitHub user
D:\windows-dev-setup\github\Another-User\repo1
```

Without a D: drive the same tree is created under `~\windows-dev-setup`.

## New machine

From a normal (not administrator) PowerShell window:

```powershell
irm https://raw.githubusercontent.com/Akash-Mittal/windows-dev-setup-scoop/main/bootstrap.ps1 | iex
```

`bootstrap.ps1` installs Scoop and git, reads `root_dir` from the CSV on GitHub, clones this repo into
`<root_dir>\windows-dev-setup`, and runs `setup.ps1`. (Set `$env:DEV_SETUP_DIR` first to clone somewhere else.)

## Existing machine

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File setup.ps1            # install what's missing, register startup
powershell -NoProfile -ExecutionPolicy Bypass -File setup.ps1 -DryRun    # show what it would do
powershell -NoProfile -ExecutionPolicy Bypass -File startup.ps1 -DryRun -ShowSummary   # preview the login run
```

## What `setup.ps1` does

1. Installs Scoop, then git, the buckets and packages (`scoop_buckets`, `scoop_packages`).
2. Installs winget packages (`winget_packages`).
3. Runs one-off commands such as pip, composer and Android SDK installs (`post_install`).
4. Runs one-off scripts: Notepad++ file associations, Rainmeter skins, GitHub checkout (`setup_scripts`).
5. Registers `startup.ps1` to run at login with no window: a scheduled task named
   `windows-dev-setup-startup`, or a shortcut in the Startup folder if a task can't be created.

It never prompts, and skips anything already installed. Log: `logs\setup-*.log`.

## What `startup.ps1` does

1. Waits `start_delay_seconds`, then starts every enabled `startup_apps` row in order.
   Missing apps are logged and skipped, never fatal.
2. Runs `scoop\start-scoop-update.ps1` every `scoop_update_every_days` days.
3. Writes `logs\startup-*.log`; output of each script goes to `logs\items\<name>.log`.
4. Optionally shows a summary that closes itself (`show_summary`, `summary_timeout_seconds`).

## Configuration: `windows_dev_setup.csv`

One flat CSV; the `worksheet` column groups rows into "sheets".

```csv
worksheet,config,value,args,enabled
startup_apps,IntelliJ IDEA,~\scoop\apps\idea\current\IDE\bin\idea64.exe,,
scoop_packages,libreoffice,,,false
```

* `args` and `enabled` are optional. `enabled` = `false` turns a row off.
* Paths may use `~` (your user folder), `{repo}` (this repo), `{workspace}` (`<root_dir>\windows-dev-setup`) and `%ENV_VARS%`.

| Worksheet | config | value | args |
|---|---|---|---|
| `setup_settings` | `register_startup` | `true` / `false` | |
| `startup_settings` | `start_delay_seconds`, `show_summary`, `summary_timeout_seconds`, `scoop_update_every_days`, `autohotkey_exe` | setting | |
| `scoop_buckets` | bucket name | optional bucket URL | |
| `scoop_packages` | package name | | |
| `winget_packages` | package id | source (`winget`, `msstore`) | |
| `post_install` | label | PowerShell command | |
| `setup_scripts` | label | script path | arguments |
| `startup_apps` | label | `.exe`, `.ps1` or `.ahk` path | arguments |
| `github_config` | see [github](./github/README.md) | | |
| `general` | `root_dir`, `project_dir_name` | e.g. `D:`, `windows-dev-setup` | |
| `github_users` | GitHub user name | | |
| `github_builds` | `<user>/<repo>` | build command | |
| `notepad_config` | `notepad_exe`, `file_extensions`, `open_file` | | |
| `chrome_config` | see [chrome](./chrome/README.md) | | |

### Per-machine overrides

Copy `windows_dev_setup.local.example.csv` to `windows_dev_setup.local.csv` (gitignored).
A worksheet+config pair listed there replaces every row with that pair in the main CSV,
e.g. a different `root_dir`, or `enabled` = `false` for an app you don't want on this machine.

## Layout

| Path | Purpose |
|---|---|
| `bootstrap.ps1`, `setup.ps1`, `startup.ps1` | Entry points |
| `lib\common.ps1` | Shared helpers: CSV config, logging, launching |
| [autohotkey](./autohotkey/README.md) | Cisco VPN auto-login |
| [chrome](./chrome/README.md) | Chrome windows per profile |
| [clear-cache](./clear-cache/README.md) | Clears temp and Chrome caches |
| [docker](./docker/README.md) | MongoDB + ActiveMQ via Docker Compose |
| [github](./github/README.md) | Clone your repos; keep them fresh and built |
| [intellij](./intellij/README.md) | IntelliJ settings to import by hand |
| [notepad](./notepad/README.md) | Notepad++ associations and files to open |
| [rainmeter](./rainmeter/README.md) | Desktop skins |
| [scoop](./scoop/README.md) | Scoop update |

Gitignored: cloned repos (`github\<user>\`), `logs\`, `.state\`, `windows_dev_setup.local.csv`.
