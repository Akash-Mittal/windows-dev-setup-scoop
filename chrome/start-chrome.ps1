param(
    [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$Profiles,

    [string]$ConfigPath,

    [string]$ChromeExe = "chrome.exe",

    [int]$DelayMs = 150
)

$ErrorActionPreference = "Stop"

$ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }

if (-not $ConfigPath -or [string]::IsNullOrWhiteSpace($ConfigPath)) {
    $ConfigPath = Join-Path $ScriptDir "chrome.json"
}

try {
    if (!(Test-Path -LiteralPath $ConfigPath)) {
        Write-Error "Config not found: $ConfigPath"
        exit 1
    }

    $raw = Get-Content -LiteralPath $ConfigPath -Raw
    $config = $raw | ConvertFrom-Json

    if ($null -eq $config.profiles) {
        Write-Error "Invalid config: missing 'profiles'"
        exit 1
    }

    $profilesMap = @{}
    foreach ($p in $config.profiles.PSObject.Properties) {
        $profilesMap[$p.Name.ToLowerInvariant()] = $p.Value
    }

    if (-not $Profiles -or $Profiles.Count -eq 0) {
        $Profiles = $profilesMap.Keys
    }

    foreach ($Profile in $Profiles) {
        $key = $Profile.ToLowerInvariant()

        if (-not $profilesMap.ContainsKey($key)) {
            $available = ($profilesMap.Keys -join ", ")
            Write-Error "Profile '$Profile' not found. Available: $available"
            continue
        }

        $profileConfig = $profilesMap[$key]

        $profileDir = $profileConfig.profileDirectory
        if ([string]::IsNullOrWhiteSpace($profileDir)) {
            Write-Error "Profile '$Profile' missing 'profileDirectory'"
            continue
        }

        $urls = @()
        if ($null -ne $profileConfig.runOnStartup -and $null -ne $profileConfig.runOnStartup.urls) {
            $urls = @($profileConfig.runOnStartup.urls) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
        }

        if ($urls.Count -eq 0) {
            Write-Error "No URLs configured for profile '$Profile'"
            continue
        }

        try {
            $args = @("--new-window", "--profile-directory=$profileDir") + $urls
            Start-Process -FilePath $ChromeExe -ArgumentList $args | Out-Null
            Start-Sleep -Milliseconds $DelayMs
        } catch {
            Write-Error "Failed opening profile '$Profile'"
            Write-Error $_
        }
    }
} catch {
    Write-Error $_
    exit 1
}

Read-Host "Press Enter to exit..."