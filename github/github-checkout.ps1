# Clones every repo of each user in worksheet github_users that is not checked out yet, into
#   <workspace>\github\<user>\<repo>        (workspace: general,root_dir + project_dir_name)
# Uses gh when it is logged in (includes your private repos), otherwise the public GitHub API
# ($env:GITHUB_TOKEN is sent when set).

. (Join-Path $PSScriptRoot "..\lib\common.ps1")

# Runs unattended at login: fail instead of waiting on a credentials prompt.
$env:GIT_TERMINAL_PROMPT = "0"
$env:GCM_INTERACTIVE     = "never"

$githubDir = Join-Path (Get-WorkspaceDir) "github"
$users = @(Get-ConfigRows "github_users" | ForEach-Object { $_.Config })

if ($users.Count -eq 0) {
    Write-Warning "No users in worksheet github_users. Nothing to clone."
    exit 0
}

# Returns objects with Name and Url (clone URL) for every repo of the user.
function Get-GitHubRepos {
    param([string]$User)

    if (Get-Command gh -ErrorAction SilentlyContinue) {
        & gh auth status *> $null
        if ($LASTEXITCODE -eq 0) {
            $json = & gh repo list $User --limit 1000 --json "name,url"
            # Windows PowerShell 5.1 emits a parsed JSON array as ONE object, so loop over it explicitly.
            $parsed = $json | Out-String | ConvertFrom-Json
            $repos = @()
            foreach ($item in $parsed) {
                $repos += [pscustomobject]@{ Name = $item.name; Url = "$($item.url).git" }
            }
            return $repos
        }
    }

    $headers = @{ "User-Agent" = "windows-dev-setup" }
    if ($env:GITHUB_TOKEN) { $headers.Authorization = "Bearer $env:GITHUB_TOKEN" }

    $repos = @()
    $page = 1
    while ($true) {
        $response = Invoke-RestMethod -Headers $headers -Uri "https://api.github.com/users/$User/repos?per_page=100&page=$page"
        $pageRepos = @()
        foreach ($item in $response) {
            if ($item.name) { $pageRepos += [pscustomobject]@{ Name = $item.name; Url = $item.clone_url } }
        }
        if ($pageRepos.Count -eq 0) { break }
        $repos += $pageRepos
        $page++
    }
    $repos
}

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
$anyFailed = $false

foreach ($user in $users) {
    $userDir = Join-Path $githubDir $user
    Write-Host "========================================"
    Write-Host "$user -> $userDir"

    try {
        $repos = @(Get-GitHubRepos $user)
    } catch {
        Write-Warning "$user | could not list repos: $($_.Exception.Message)"
        $anyFailed = $true
        continue
    }

    New-Item -ItemType Directory -Force -Path $userDir | Out-Null
    foreach ($repo in $repos) {
        $target = Join-Path $userDir $repo.Name
        if (Test-Path -LiteralPath $target) { continue }

        Write-Host "$user/$($repo.Name) | git clone"
        & cmd.exe /c "git clone --quiet `"$($repo.Url)`" `"$target`" 2>&1" | Out-Host
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "$user/$($repo.Name) | clone FAILED"
            $anyFailed = $true
        }
    }
    Write-Host "$user | $($repos.Count) repos"
}

if ($anyFailed) {
    Write-Error "One or more repositories failed to clone."
    exit 1
}
Write-Host "All repositories checked out to $githubDir."
