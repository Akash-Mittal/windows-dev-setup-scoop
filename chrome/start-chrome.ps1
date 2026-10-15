# Opens one Chrome window per profile with that profile's URLs (worksheet chrome_config).
# Usage: start-chrome.ps1 [profile ...]
# Profiles default to chrome_config/startup_profiles, or every configured profile.
param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Profiles)

. (Join-Path $PSScriptRoot "..\lib\common.ps1")

$Worksheet = "chrome_config"

function Find-Chrome {
    param([string]$Configured)

    if ($Configured) {
        $path = Expand-ConfigPath $Configured
        if (Test-Path -LiteralPath $path) { return $path }
        $command = Get-Command $Configured -ErrorAction SilentlyContinue
        if ($command) { return $command.Source }
    }

    $candidates = @(
        (Join-Path $env:USERPROFILE "scoop\apps\googlechrome\current\chrome.exe"),
        (Join-Path $env:ProgramFiles "Google\Chrome\Application\chrome.exe"),
        (Join-Path ${env:ProgramFiles(x86)} "Google\Chrome\Application\chrome.exe"),
        (Join-Path $env:LOCALAPPDATA "Google\Chrome\Application\chrome.exe")
    )
    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) { return $candidate }
    }

    $command = Get-Command chrome.exe -ErrorAction SilentlyContinue
    if ($command) { return $command.Source }
    $null
}

function ConvertTo-ArgumentString {
    param([string[]]$Arguments)
    ($Arguments | ForEach-Object { if ($_ -match '[\s"]') { '"' + ($_ -replace '"', '\"') + '"' } else { $_ } }) -join " "
}

$chromeExe = Find-Chrome (Get-ConfigValue $Worksheet "chrome_exe" "")
if (-not $chromeExe) {
    Write-Error "Chrome not found. Set chrome_config,chrome_exe in $DevSetupCsv"
    exit 1
}

$delayMs = [int](Get-ConfigValue $Worksheet "delay_ms" "150")

# Profile names from "<profile>.profile_directory" rows, in file order.
$available = @(Get-ConfigRows $Worksheet |
    Where-Object { $_.Config -like "*.profile_directory" } |
    ForEach-Object { $_.Config.Substring(0, $_.Config.Length - ".profile_directory".Length).ToLowerInvariant() } |
    Select-Object -Unique)

if ($available.Count -eq 0) {
    Write-Error "No profiles found in worksheet $Worksheet (expected <profile>.profile_directory rows)"
    exit 1
}

if (-not $Profiles -or $Profiles.Count -eq 0) {
    $Profiles = @((Get-ConfigValue $Worksheet "startup_profiles" "") -split "\s+" | Where-Object { $_ })
}
if ($Profiles.Count -eq 0) {
    $Profiles = $available
}

$anyFailed = $false

foreach ($profileName in $Profiles) {
    $key = $profileName.ToLowerInvariant()

    if ($available -notcontains $key) {
        Write-Error "Profile '$profileName' not found. Available: $($available -join ' ')"
        $anyFailed = $true
        continue
    }

    $profileDir = Get-ConfigValue $Worksheet "$key.profile_directory" ""
    $urls = @(Get-ConfigValues $Worksheet "$key.url")

    if ($urls.Count -eq 0) {
        Write-Error "No URLs configured for profile '$profileName' ($key.url rows)"
        $anyFailed = $true
        continue
    }

    Write-Host "$profileName | profile-directory=$profileDir | $($urls.Count) url(s)"
    $arguments = @("--new-window", "--profile-directory=$profileDir") + $urls
    Start-Process -FilePath $chromeExe -ArgumentList (ConvertTo-ArgumentString $arguments)
    Start-Sleep -Milliseconds $delayMs
}

if ($anyFailed) { exit 1 }
