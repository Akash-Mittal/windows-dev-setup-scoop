# Keeps every repo in <workspace>\github\<user>\<repo> fresh, and builds the ones with a build command.
# Runs at login (startup_apps) or by hand.
#
# Never discards local work: it only fetches and fast-forwards. A repo that cannot
# fast-forward (local changes in the way, diverged branch) is left as is and reported.
#
# Settings (windows_dev_setup.csv):
#   github_config,clone_missing_on_startup   true: first clone new repos of github_users (github-checkout.ps1)
#   github_config,build_on_startup           false: refresh only
#   github_builds,<user>/<repo>,<command>    build command for one repo
# Build output goes to logs\builds\<user>_<repo>.log.

. (Join-Path $PSScriptRoot "..\lib\common.ps1")

# Runs unattended at login: fail instead of waiting on a credentials prompt.
$env:GIT_TERMINAL_PROMPT = "0"
$env:GCM_INTERACTIVE     = "never"

$githubDir    = Join-Path (Get-WorkspaceDir) "github"
$buildEnabled = Test-ConfigTrue "github_config" "build_on_startup" $true
$buildLogDir  = Join-Path $DevSetupLogDir "builds"

$builds = @{}
foreach ($row in Get-ConfigRows "github_builds") {
    if ($row.Value) { $builds[$row.Config.Replace("\", "/").ToLowerInvariant()] = $row.Value }
}

# Runs git in a repo; returns @{ Ok; Output } instead of throwing.
function Invoke-Git {
    param([string]$RepoPath, [string[]]$GitArgs)
    $output = & cmd.exe /c "git -C `"$RepoPath`" $($GitArgs -join ' ') 2>&1"
    @{ Ok = ($LASTEXITCODE -eq 0); Output = ($output | Out-String).Trim() }
}

# fetch + fast-forward only. Returns a short status for the summary.
function Update-Repo {
    param([string]$RepoPath)

    $fetch = Invoke-Git $RepoPath @("fetch", "--all", "--prune", "--quiet")
    if (-not $fetch.Ok) { throw "fetch failed: $($fetch.Output)" }

    $branch = (Invoke-Git $RepoPath @("symbolic-ref", "--short", "-q", "HEAD")).Output
    if (-not $branch) { return "fetched (detached HEAD, not merged)" }

    $upstream = Invoke-Git $RepoPath @("rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}")
    if (-not $upstream.Ok) { return "fetched ($branch has no upstream)" }

    $before = (Invoke-Git $RepoPath @("rev-parse", "HEAD")).Output
    # --ff-only never rewrites history, and git refuses it if it would overwrite local changes.
    $merge = Invoke-Git $RepoPath @("merge", "--ff-only", "--quiet", "@{u}")
    if (-not $merge.Ok) { return "fetched; $branch NOT fast-forwarded (local commits or changes in the way)" }

    $after = (Invoke-Git $RepoPath @("rev-parse", "HEAD")).Output
    if ($before -eq $after) { return "$branch up to date" }
    "$branch fast-forwarded to $($after.Substring(0, 8))"
}

function Invoke-Build {
    param([string]$Name, [string]$RepoPath, [string]$Command)

    New-Item -ItemType Directory -Force -Path $buildLogDir | Out-Null
    $logFile = Join-Path $buildLogDir ((ConvertTo-SafeFileName $Name) + ".log")

    Push-Location $RepoPath
    try {
        & cmd.exe /c "$Command > `"$logFile`" 2>&1"
        $exitCode = $LASTEXITCODE
    } finally {
        Pop-Location
    }
    if ($exitCode -ne 0) { throw "build failed (exit $exitCode), see $logFile" }
    "build OK"
}

# ---------------------------------------------------------------- main

if (Test-ConfigTrue "github_config" "clone_missing_on_startup" $false) {
    & (Join-Path $PSScriptRoot "github-checkout.ps1")
    if ($LASTEXITCODE -ne 0) { Add-Result "GitHub checkout" "Failed" "see the output above" }
}

if (-not (Test-Path -LiteralPath $githubDir)) {
    Write-Log "No repos yet in $githubDir"
    exit 0
}

foreach ($userDir in Get-ChildItem -LiteralPath $githubDir -Directory) {
    foreach ($repoDir in Get-ChildItem -LiteralPath $userDir.FullName -Directory) {
        if (-not (Test-Path -LiteralPath (Join-Path $repoDir.FullName ".git"))) { continue }
        $name = "$($userDir.Name)/$($repoDir.Name)"

        try {
            $status = Update-Repo $repoDir.FullName
            $build = $builds[$name.ToLowerInvariant()]
            if ($build -and $buildEnabled) {
                Write-Log "$name | $status | building: $build"
                $status += "; " + (Invoke-Build $name $repoDir.FullName $build)
            }
            Add-Result $name "Ok" $status
        } catch {
            Add-Result $name "Failed" "$($_.Exception.Message)"
        }
    }
}

Write-Log "========================================"
Write-Log "Repos finished: $(Get-ResultSummary)"
if (Test-AnyFailed) { exit 1 }
