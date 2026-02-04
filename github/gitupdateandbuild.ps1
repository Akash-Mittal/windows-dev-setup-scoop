param(
    [string]$JsonPath = (Join-Path $PSScriptRoot "github.json")
)

$ErrorActionPreference = "Stop"

function Write-DebugLog([string]$msg) { Write-Host "[DEBUG] $msg" }
function Write-ErrorLog([string]$msg) { Write-Host "[ERROR] $msg" }

function Split-CommandLine([string]$command) {
    if ([string]::IsNullOrWhiteSpace($command)) { return @() }
    $pattern = '(?:"([^"]*)"|''([^'']*)''|(\S+))'
    $matches = [regex]::Matches($command, $pattern)

    $parts = New-Object System.Collections.Generic.List[string]
    foreach ($m in $matches) {
        if ($m.Groups[1].Success) { $parts.Add($m.Groups[1].Value) }
        elseif ($m.Groups[2].Success) { $parts.Add($m.Groups[2].Value) }
        elseif ($m.Groups[3].Success) { $parts.Add($m.Groups[3].Value) }
    }
    return $parts.ToArray()
}

function Invoke-Exe([string]$file, [string[]]$argList, [string]$workDir) {
    $filtered = @($argList | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    if (-not $filtered -or $filtered.Count -eq 0) {
        throw "Argument list is empty for $file"
    }
    $p = Start-Process -FilePath $file -ArgumentList $filtered -WorkingDirectory $workDir -NoNewWindow -Wait -PassThru
    if ($p.ExitCode -ne 0) {
        throw "Command failed ($file $($filtered -join ' ')) exitCode=$($p.ExitCode)"
    }
}

function Start-ExeAsync([string]$file, [string[]]$argList, [string]$workDir, [string]$stdoutPath, [string]$stderrPath) {
    $filtered = @($argList | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    if (-not $filtered -or $filtered.Count -eq 0) {
        throw "Argument list is empty for $file"
    }

    $params = @{
        FilePath         = $file
        ArgumentList     = $filtered
        WorkingDirectory = $workDir
        NoNewWindow      = $true
        PassThru         = $true
    }

    if (-not [string]::IsNullOrWhiteSpace($stdoutPath)) { $params.RedirectStandardOutput = $stdoutPath }
    if (-not [string]::IsNullOrWhiteSpace($stderrPath)) { $params.RedirectStandardError  = $stderrPath }

    return Start-Process @params
}

if (-not (Test-Path $JsonPath -PathType Leaf)) {
    Write-ErrorLog "github.json not found: $JsonPath"
    exit 1
}

try {
    $cfg = Get-Content -Raw -Path $JsonPath | ConvertFrom-Json
} catch {
    Write-ErrorLog "Failed to parse JSON: $($_.Exception.Message)"
    exit 1
}

$repos = $cfg.github.repos
if (-not $repos -or $repos.Count -eq 0) {
    Write-ErrorLog "No repos found at github.repos in $JsonPath"
    exit 1
}

$anyFailed = $false
$buildProcesses = @()

foreach ($repo in $repos) {
    $repoPath = $repo.path
    $buildCommand = $repo.buildCommand

    if ([string]::IsNullOrWhiteSpace($repoPath)) { continue }

    Write-DebugLog "Repo: $repoPath"

    if (-not (Test-Path $repoPath -PathType Container)) {
        Write-ErrorLog "Path not found: $repoPath"
        $anyFailed = $true
        continue
    }

    if (-not (Test-Path (Join-Path $repoPath ".git") -PathType Container)) {
        Write-ErrorLog "Not a git repo (missing .git): $repoPath"
        $anyFailed = $true
        continue
    }

    try {
        Invoke-Exe "git" @("fetch", "origin", "--prune") $repoPath
        Invoke-Exe "git" @("checkout", "-B", "main", "origin/HEAD") $repoPath
        Invoke-Exe "git" @("reset", "--hard", "origin/HEAD") $repoPath
        Invoke-Exe "git" @("clean", "-fdx") $repoPath

        if ([string]::IsNullOrWhiteSpace($buildCommand)) {
            Write-DebugLog "No buildCommand set, skipping build"
            continue
        }

        $parts = Split-CommandLine $buildCommand
        if (-not $parts -or $parts.Count -eq 0) {
            throw "Build command could not be parsed: $buildCommand"
        }

        $exe = $parts[0]
        $args = @()
        if ($parts.Count -gt 1) { $args = $parts[1..($parts.Count - 1)] }

        $stdout = Join-Path $repoPath "build.out.log"
        $stderr = Join-Path $repoPath "build.err.log"

        Write-DebugLog "build (background): $buildCommand"
        $p = Start-ExeAsync $exe $args $repoPath $stdout $stderr

        $buildProcesses += [pscustomobject]@{
            Repo    = $repoPath
            Command = $buildCommand
            Pid     = $p.Id
            Process = $p
            StdOut  = $stdout
            StdErr  = $stderr
        }
    } catch {
        Write-ErrorLog "FAILED (pre-build): $repoPath | $($_.Exception.Message)"
        $anyFailed = $true
        continue
    }
}

foreach ($bp in $buildProcesses) {
    Write-DebugLog "Waiting: $($bp.Repo) (pid=$($bp.Pid))"
    $bp.Process.WaitForExit()

    if ($bp.Process.ExitCode -ne 0) {
        Write-ErrorLog "BUILD FAILED: $($bp.Repo) exitCode=$($bp.Process.ExitCode) | logs: $($bp.StdOut) , $($bp.StdErr)"
        $anyFailed = $true
    } else {
        Write-DebugLog "BUILD OK: $($bp.Repo) | logs: $($bp.StdOut) , $($bp.StdErr)"
    }
}

if ($anyFailed) {
    Write-ErrorLog "One or more repositories failed."
    exit 1
}

Write-DebugLog "All repositories updated and built successfully."
exit 0
