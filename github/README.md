# GitHub: clone, refresh and build

All repos live in the workspace (`general,root_dir` + `project_dir_name`, e.g. `D:\windows-dev-setup`):

```
<workspace>\github\<user>\<repo>
D:\windows-dev-setup\github\Akash-Mittal\repo1
D:\windows-dev-setup\github\Another-User\repo1
```

## `github-checkout.ps1`

Clones every repo of each user in worksheet `github_users` that isn't checked out yet.
Runs from `setup.ps1`, and at login when `clone_missing_on_startup` is `true`.

Uses `gh` when it is logged in (includes your private repos), otherwise the public GitHub API
(`$env:GITHUB_TOKEN` is sent when set).

## `start-git-update-build.ps1`

Runs at login (`startup_apps`, "Git refresh and build"):

1. Clones new repos (if `clone_missing_on_startup`).
2. Refreshes every repo under `<workspace>\github`.
3. Builds the repos that have a `github_builds` row.

**Refresh never discards local work.** It runs `git fetch --all --prune`, then `git merge --ff-only` on the
current branch's upstream. If local commits or uncommitted changes are in the way, the repo is left as it is and
reported. There is no reset, no clean, and no branch switch.

Git runs non-interactively, so a repo that needs credentials fails and is reported instead of waiting on a prompt.
Build output goes to `logs\builds\<user>_<repo>.log`.

## Settings

| Row | Meaning |
|---|---|
| `github_users,<user>` | GitHub user whose repos to clone (one row per user) |
| `github_config,clone_missing_on_startup,true` | Clone new repos at login, not only during setup |
| `github_config,build_on_startup,true` | Run build commands at login |
| `github_builds,<user>/<repo>,<command>` | Build command for one repo, e.g. `github_builds,Akash-Mittal/bp-wallet,mvn clean package` |

## Run by hand

```powershell
.\github-checkout.ps1
.\start-git-update-build.ps1
```
