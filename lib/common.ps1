# Shared helpers for setup.ps1, startup.ps1 and the per-tool scripts.
# Dot-source it:  . (Join-Path $PSScriptRoot "lib\common.ps1")
#
# Config lives in windows_dev_setup.csv (columns: worksheet,config,value,args,enabled).
# windows_dev_setup.local.csv (gitignored, same columns) overrides it per machine:
# a worksheet+config pair listed there replaces every row with that pair.

$DevSetupRoot     = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$DevSetupCsv      = Join-Path $DevSetupRoot "windows_dev_setup.csv"
$DevSetupLocalCsv = Join-Path $DevSetupRoot "windows_dev_setup.local.csv"
$DevSetupLogDir   = Join-Path $DevSetupRoot "logs"
$DevSetupStateDir = Join-Path $DevSetupRoot ".state"

$script:DevConfigRows = $null
$script:DevLogFile    = $null
$script:DevResults    = New-Object System.Collections.ArrayList

# ---------------------------------------------------------------- config

function Read-DevConfigFile {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) { return @() }

    @(Import-Csv -LiteralPath $Path -Encoding UTF8 |
        Where-Object { $_.worksheet -and -not "$($_.worksheet)".Trim().StartsWith("#") } |
        ForEach-Object {
            [pscustomobject]@{
                Worksheet = "$($_.worksheet)".Trim()
                Config    = "$($_.config)".Trim()
                Value     = "$($_.value)".Trim()
                Args      = "$($_.args)".Trim()
                Enabled   = ("$($_.enabled)".Trim() -ne "false")
            }
        })
}

function Get-DevConfigKey {
    param($Row)
    "$($Row.Worksheet)|$($Row.Config)".ToLowerInvariant()
}

# All rows (enabled and disabled), base CSV merged with the local override.
function Get-AllConfigRows {
    if ($null -ne $script:DevConfigRows) { return $script:DevConfigRows }

    if (-not (Test-Path -LiteralPath $DevSetupCsv)) {
        throw "Config not found: $DevSetupCsv"
    }

    $base  = Read-DevConfigFile $DevSetupCsv
    $local = Read-DevConfigFile $DevSetupLocalCsv

    $localByKey = @{}
    foreach ($row in $local) {
        $key = Get-DevConfigKey $row
        if (-not $localByKey.ContainsKey($key)) { $localByKey[$key] = New-Object System.Collections.ArrayList }
        [void]$localByKey[$key].Add($row)
    }

    # Overridden keys keep the position of their first base row, so startup order is stable.
    $merged = New-Object System.Collections.ArrayList
    $used   = @{}
    foreach ($row in $base) {
        $key = Get-DevConfigKey $row
        if (-not $localByKey.ContainsKey($key)) { [void]$merged.Add($row); continue }
        if (-not $used.ContainsKey($key)) {
            $used[$key] = $true
            foreach ($override in $localByKey[$key]) { [void]$merged.Add($override) }
        }
    }
    foreach ($row in $local) {
        if (-not $used.ContainsKey((Get-DevConfigKey $row))) { [void]$merged.Add($row) }
    }

    $script:DevConfigRows = $merged.ToArray()
    $script:DevConfigRows
}

# Enabled rows of a worksheet, in file order.
function Get-ConfigRows {
    param([Parameter(Mandatory = $true)][string]$Worksheet)
    @(Get-AllConfigRows | Where-Object { $_.Enabled -and $_.Worksheet -eq $Worksheet })
}

# Every value of one config in a worksheet (for repeated rows like personal.url).
function Get-ConfigValues {
    param(
        [Parameter(Mandatory = $true)][string]$Worksheet,
        [Parameter(Mandatory = $true)][string]$Name
    )
    @(Get-ConfigRows $Worksheet | Where-Object { $_.Config -eq $Name -and $_.Value } | ForEach-Object { $_.Value })
}

function Get-ConfigValue {
    param(
        [Parameter(Mandatory = $true)][string]$Worksheet,
        [Parameter(Mandatory = $true)][string]$Name,
        [string]$Default = ""
    )
    $values = @(Get-ConfigValues $Worksheet $Name)
    if ($values.Count -gt 0) { return $values[0] }
    $Default
}

function Test-ConfigTrue {
    param([string]$Worksheet, [string]$Name, [bool]$Default = $false)
    $value = Get-ConfigValue $Worksheet $Name ""
    if (-not $value) { return $Default }
    $value -eq "true"
}

# <root_dir>\<project_dir_name>, e.g. D:\windows-dev-setup. Everything this project creates lives here.
# Falls back to the user folder when root_dir is empty or does not exist (e.g. no D: drive).
function Get-WorkspaceDir {
    $root = [Environment]::ExpandEnvironmentVariables((Get-ConfigValue "general" "root_dir" "~"))
    if ($root -match "^[A-Za-z]:$") { $root += "\" }
    if ($root -eq "~" -or $root.StartsWith("~\")) { $root = $env:USERPROFILE + $root.Substring(1) }
    if (-not $root -or -not [IO.Directory]::Exists($root)) { $root = $env:USERPROFILE }

    Join-Path $root (Get-ConfigValue "general" "project_dir_name" "windows-dev-setup")
}

# Expands {repo}, {workspace}, a leading ~ and %ENV_VARS% in a configured path.
function Expand-ConfigPath {
    param([string]$Path)
    if (-not $Path) { return $Path }

    $expanded = $Path.Replace("{repo}", $DevSetupRoot)
    if ($expanded.Contains("{workspace}")) { $expanded = $expanded.Replace("{workspace}", (Get-WorkspaceDir)) }
    if ($expanded -eq "~") {
        $expanded = $env:USERPROFILE
    } elseif ($expanded.StartsWith("~\") -or $expanded.StartsWith("~/")) {
        $expanded = Join-Path $env:USERPROFILE $expanded.Substring(2)
    }
    [Environment]::ExpandEnvironmentVariables($expanded)
}

function Expand-ConfigArgs {
    param([string]$Arguments)
    if (-not $Arguments) { return "" }
    [Environment]::ExpandEnvironmentVariables($Arguments.Replace("{repo}", $DevSetupRoot))
}

# ---------------------------------------------------------------- logging

# -Transcript records everything printed (used by setup, which runs in a visible window).
# Without it, Write-Log appends to the log file itself (used by the silent startup).
function Start-DevLog {
    param([Parameter(Mandatory = $true)][string]$Name, [switch]$Transcript, [int]$Keep = 20)

    New-Item -ItemType Directory -Force -Path $DevSetupLogDir | Out-Null
    Get-ChildItem -LiteralPath $DevSetupLogDir -Filter "$Name-*.log" |
        Sort-Object Name -Descending | Select-Object -Skip ($Keep - 1) |
        Remove-Item -Force -ErrorAction SilentlyContinue

    $file = Join-Path $DevSetupLogDir ("{0}-{1:yyyyMMdd-HHmmss}.log" -f $Name, (Get-Date))
    if ($Transcript) {
        Start-Transcript -LiteralPath $file | Out-Null
    } else {
        $script:DevLogFile = $file
    }
    $file
}

function Write-Log {
    param([string]$Message, [ValidateSet("INFO", "WARN", "ERROR")][string]$Level = "INFO")

    $line = "{0:HH:mm:ss} [{1}] {2}" -f (Get-Date), $Level, $Message
    if ($script:DevLogFile) {
        Add-Content -LiteralPath $script:DevLogFile -Value $line -Encoding UTF8
    }
    switch ($Level) {
        "WARN"  { Write-Host $line -ForegroundColor Yellow }
        "ERROR" { Write-Host $line -ForegroundColor Red }
        default { Write-Host $line }
    }
}

# Status is one of: Started, Installed, Ok, Present, Skipped, Failed, DryRun.
function Add-Result {
    param([string]$Name, [string]$Status, [string]$Detail = "")

    [void]$script:DevResults.Add([pscustomobject]@{ Name = $Name; Status = $Status; Detail = $Detail })
    $level = "INFO"
    if ($Status -eq "Failed") { $level = "ERROR" } elseif ($Status -eq "Skipped") { $level = "WARN" }
    $message = "$Status | $Name"
    if ($Detail) { $message += " | $Detail" }
    Write-Log $message $level
}

function Get-ResultSummary {
    $counts = $script:DevResults | Group-Object Status | Sort-Object Name |
        ForEach-Object { "$($_.Count) $($_.Name.ToLowerInvariant())" }
    $lines = @(($counts -join ", "))
    foreach ($r in $script:DevResults | Where-Object { $_.Status -in @("Failed", "Skipped") }) {
        $lines += "$($r.Status): $($r.Name) - $($r.Detail)"
    }
    $lines -join [Environment]::NewLine
}

function Test-AnyFailed {
    @($script:DevResults | Where-Object { $_.Status -eq "Failed" }).Count -gt 0
}

# Message box that closes itself after the timeout, so it never blocks a login.
function Show-DevSummary {
    param([string]$Title, [string]$Text, [int]$TimeoutSeconds = 30)

    $icon = 64   # information
    if (Test-AnyFailed) { $icon = 48 }   # warning
    $shell = New-Object -ComObject WScript.Shell
    [void]$shell.Popup($Text, $TimeoutSeconds, $Title, $icon)
}

# ---------------------------------------------------------------- launching

function ConvertTo-SafeFileName {
    param([string]$Name)
    ($Name -replace "[^\w.-]+", "_").Trim("_")
}

# Starts a .ps1 (hidden, in its own powershell), an .ahk (with AutoHotkey) or any executable.
# -Wait runs it in this console and returns the exit code; otherwise it returns the process,
# and .ps1 output goes to logs\items\<name>.log.
function Start-DevItem {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$Path,
        [string]$Arguments = "",
        [switch]$Wait
    )

    $extension = [IO.Path]::GetExtension($Path).ToLowerInvariant()
    switch ($extension) {
        ".ps1" {
            $file    = "powershell.exe"
            $argLine = "-NoProfile -ExecutionPolicy Bypass -File `"$Path`" $Arguments"
        }
        ".ahk" {
            $file = Expand-ConfigPath (Get-ConfigValue "startup_settings" "autohotkey_exe" "~\scoop\apps\autohotkey\current\v2\AutoHotkey64.exe")
            if (-not (Test-Path -LiteralPath $file)) { throw "AutoHotkey not found at $file" }
            $argLine = "`"$Path`" $Arguments"
        }
        default {
            $file    = $Path
            $argLine = $Arguments
        }
    }
    $argLine = $argLine.Trim()

    $params = @{ FilePath = $file; PassThru = $true; WorkingDirectory = (Split-Path -Parent $Path) }
    if ($argLine) { $params.ArgumentList = $argLine }

    if ($Wait) {
        $process = Start-Process @params -NoNewWindow -Wait
        return $process.ExitCode
    }

    if ($extension -eq ".ps1") {
        $itemLogDir = Join-Path $DevSetupLogDir "items"
        New-Item -ItemType Directory -Force -Path $itemLogDir | Out-Null
        $logName = ConvertTo-SafeFileName $Name
        $params.WindowStyle            = "Hidden"
        $params.RedirectStandardOutput = Join-Path $itemLogDir "$logName.log"
        $params.RedirectStandardError  = Join-Path $itemLogDir "$logName.err.log"
    }
    Start-Process @params
}
