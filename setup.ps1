# Sets up a machine from windows_dev_setup.csv. Safe to re-run: anything already in place is skipped.
#   1. Scoop, git, scoop buckets and packages       (scoop_buckets, scoop_packages)
#   2. winget packages                              (winget_packages)
#   2b. zips from a vendor's own site, unpacked     (zip_installs, user_path)
#   3. one-off commands                             (post_install)
#   4. one-off scripts                              (setup_scripts)
#   5. registers startup.ps1 to run at every login  (setup_settings, register_startup)
#
# Usage:  powershell -NoProfile -ExecutionPolicy Bypass -File setup.ps1 [-DryRun]
param([switch]$DryRun)

. (Join-Path $PSScriptRoot "lib\common.ps1")

$StartupTaskName = "windows-dev-setup-startup"

# ---------------------------------------------------------------- scoop

function Get-ScoopShims {
    $root = if ($env:SCOOP) { $env:SCOOP } else { Join-Path $env:USERPROFILE "scoop" }
    Join-Path $root "shims"
}

# Rebuild this session's PATH from the registry (picks up paths added by installers)
# and make sure scoop's shims folder is always on it. Some installers rewrite PATH
# and can drop the shims entry, which makes 'scoop' disappear mid-script.
function Sync-Path {
    $shims   = Get-ScoopShims
    $machine = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    $user    = [Environment]::GetEnvironmentVariable("PATH", "User")

    if ((Test-Path $shims) -and ($user -split ";" -notcontains $shims)) {
        Write-Log "Scoop shims were missing from your user PATH. Restoring: $shims" "WARN"
        $user = (@($shims) + ($user -split ";" | Where-Object { $_ })) -join ";"
        [Environment]::SetEnvironmentVariable("PATH", $user, "User")
    }

    $env:PATH = (@($shims, $user, $machine) | Where-Object { $_ }) -join ";"
}

function Test-Scoop {
    [bool](Get-Command scoop -ErrorAction SilentlyContinue)
}

function Install-Scoop {
    if (Test-Scoop) {
        Add-Result "scoop" "Present"
        return $true
    }
    if ($DryRun) {
        Add-Result "scoop" "DryRun" "would install"
        return $false
    }

    Write-Log "Installing Scoop ..."
    # Allow local scripts for this user (needed by scoop's shims). A group policy may forbid it.
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop
    } catch {
        Write-Log "Could not set the execution policy: $($_.Exception.Message)" "WARN"
    }

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)

    $installer = Invoke-RestMethod -Uri https://get.scoop.sh
    if ($isAdmin) {
        # Scoop refuses to install from an elevated shell unless -RunAsAdmin is passed
        & ([scriptblock]::Create($installer)) -RunAsAdmin
    } else {
        & ([scriptblock]::Create($installer))
    }
    Sync-Path

    if (-not (Test-Scoop)) {
        Add-Result "scoop" "Failed" "installer did not put scoop on PATH"
        return $false
    }
    Add-Result "scoop" "Installed"
    $true
}

function Get-ScoopInstalled {
    @(scoop list 6>$null 2>$null | ForEach-Object { $_.Name })
}

function Install-ScoopPackage {
    param([string]$Name, [string[]]$Installed)

    if ($Installed -contains $Name) {
        Add-Result "scoop: $Name" "Present"
        return
    }
    if ($DryRun) {
        Add-Result "scoop: $Name" "DryRun" "would install"
        return
    }

    Sync-Path
    Write-Log "Installing $Name ..."
    scoop install $Name | Out-Host
    Sync-Path

    if ((Get-ScoopInstalled) -contains $Name) {
        Add-Result "scoop: $Name" "Installed"
    } else {
        Add-Result "scoop: $Name" "Failed" "scoop install did not complete"
    }
}

function Install-ScoopBucket {
    param([string]$Name, [string]$Url, [string[]]$Existing)

    if ($Existing -contains $Name) {
        Add-Result "bucket: $Name" "Present"
        return
    }
    if ($DryRun) {
        Add-Result "bucket: $Name" "DryRun" "would add"
        return
    }

    Write-Log "Adding bucket $Name ..."
    if ($Url) { scoop bucket add $Name $Url | Out-Host } else { scoop bucket add $Name | Out-Host }

    if (@(scoop bucket list 6>$null 2>$null | ForEach-Object { $_.Name }) -contains $Name) {
        Add-Result "bucket: $Name" "Installed"
    } else {
        Add-Result "bucket: $Name" "Failed" "scoop bucket add did not complete"
    }
}

# ---------------------------------------------------------------- winget

function Install-WingetPackage {
    param([string]$Id, [string]$Source)

    if (-not $Source) { $Source = "winget" }
    $name = "winget: $Id"

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Add-Result $name "Skipped" "winget is not available"
        return
    }

    winget list -e --id $Id --source $Source --accept-source-agreements *> $null
    if ($LASTEXITCODE -eq 0) {
        Add-Result $name "Present"
        return
    }
    if ($DryRun) {
        Add-Result $name "DryRun" "would install from $Source"
        return
    }

    Write-Log "Installing $Id (winget, $Source) ..."
    winget install -e --id $Id --source $Source --accept-package-agreements --accept-source-agreements | Out-Host
    if ($LASTEXITCODE -eq 0) {
        Add-Result $name "Installed"
    } else {
        Add-Result $name "Failed" "winget exit code $LASTEXITCODE"
    }
}

# ---------------------------------------------------------------- zip installs

# Downloads a zip over HTTPS and unpacks it into a folder. Skipped when the folder already has files.
# For tools whose vendor site is the only trusted source (no scoop/winget package used).
function Install-ZipPackage {
    param([string]$Name, [string]$Url, [string]$TargetDir)

    $label = "zip: $Name"
    if (-not $Url.StartsWith("https://")) {
        Add-Result $label "Failed" "refusing a non-HTTPS download url: $Url"
        return
    }
    if (-not $TargetDir) {
        Add-Result $label "Failed" "no target folder in the args column"
        return
    }
    if ((Test-Path -LiteralPath $TargetDir) -and (Get-ChildItem -LiteralPath $TargetDir -Force | Select-Object -First 1)) {
        Add-Result $label "Present" $TargetDir
        return
    }
    if ($DryRun) {
        Add-Result $label "DryRun" "would download $Url to $TargetDir"
        return
    }

    $zip = Join-Path $env:TEMP ("dev-setup-" + (ConvertTo-SafeFileName $Name) + ".zip")
    try {
        Write-Log "Downloading $Url ..."
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
        $ProgressPreference = "SilentlyContinue"   # the progress bar makes Invoke-WebRequest very slow in 5.1
        Invoke-WebRequest -Uri $Url -OutFile $zip -UseBasicParsing -ErrorAction Stop

        New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
        Expand-Archive -LiteralPath $zip -DestinationPath $TargetDir -Force -ErrorAction Stop

        # A zip holding a single top-level folder is flattened, so the tools sit directly in $TargetDir.
        $top = @(Get-ChildItem -LiteralPath $TargetDir -Force)
        if ($top.Count -eq 1 -and $top[0].PSIsContainer) {
            Get-ChildItem -LiteralPath $top[0].FullName -Force | Move-Item -Destination $TargetDir
            Remove-Item -LiteralPath $top[0].FullName -Force
        }
        # Files downloaded from the internet carry a "blocked" mark; clear it so the tools run without warnings.
        Get-ChildItem -LiteralPath $TargetDir -Recurse -File | Unblock-File
        Add-Result $label "Installed" $TargetDir
    } catch {
        Add-Result $label "Failed" "$($_.Exception.Message)"
    } finally {
        Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
    }
}

# Adds a folder to the user PATH (persisted) so its tools work from any terminal.
function Add-UserPath {
    param([string]$Name, [string]$Folder)

    $label = "PATH: $Name"
    $user = [Environment]::GetEnvironmentVariable("PATH", "User")
    if (($user -split ";") -contains $Folder) {
        Add-Result $label "Present" $Folder
        return
    }
    if ($DryRun) {
        Add-Result $label "DryRun" "would add $Folder"
        return
    }

    [Environment]::SetEnvironmentVariable("PATH", ((@($user -split ";" | Where-Object { $_ }) + $Folder) -join ";"), "User")
    $env:PATH = "$env:PATH;$Folder"
    Add-Result $label "Ok" $Folder
}

# ---------------------------------------------------------------- commands and scripts

function Invoke-PostInstall {
    param([string]$Name, [string]$Command)

    if ($DryRun) {
        Add-Result "post_install: $Name" "DryRun" $Command
        return
    }

    Sync-Path
    Write-Log "Running $Name : $Command"
    try {
        $global:LASTEXITCODE = 0
        Invoke-Expression $Command | Out-Host
        if ($LASTEXITCODE -ne 0) { throw "exit code $LASTEXITCODE" }
        Add-Result "post_install: $Name" "Ok"
    } catch {
        Add-Result "post_install: $Name" "Failed" "$($_.Exception.Message)"
    }
}

function Invoke-SetupScript {
    param([string]$Name, [string]$Path, [string]$Arguments)

    if (-not (Test-Path -LiteralPath $Path)) {
        Add-Result "script: $Name" "Failed" "not found: $Path"
        return
    }
    if ($DryRun) {
        Add-Result "script: $Name" "DryRun" $Path
        return
    }

    Write-Log "Running $Name : $Path $Arguments"
    try {
        $exitCode = Start-DevItem -Name $Name -Path $Path -Arguments $Arguments -Wait
        if ($exitCode -ne 0) { throw "exit code $exitCode" }
        Add-Result "script: $Name" "Ok"
    } catch {
        Add-Result "script: $Name" "Failed" "$($_.Exception.Message)"
    }
}

# ---------------------------------------------------------------- startup registration

# Runs startup.ps1 at login without a window. Uses a scheduled task; if this account
# may not create one, falls back to a shortcut in the user's Startup folder.
function Register-Startup {
    $startupScript = Join-Path $DevSetupRoot "startup.ps1"
    $psArgs = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$startupScript`""

    # conhost --headless (Windows 11) starts PowerShell with no console window at all.
    if ([Environment]::OSVersion.Version.Build -ge 22000) {
        $exe  = "conhost.exe"
        $taskArgs = "--headless powershell.exe $psArgs"
    } else {
        $exe  = "powershell.exe"
        $taskArgs = $psArgs
    }

    $shortcut = Join-Path ([Environment]::GetFolderPath("Startup")) "windows-dev-setup.lnk"

    if ($DryRun) {
        Add-Result "startup registration" "DryRun" "$exe $taskArgs"
        return
    }

    try {
        $user      = "$env:USERDOMAIN\$env:USERNAME"
        $action    = New-ScheduledTaskAction -Execute $exe -Argument $taskArgs -WorkingDirectory $DevSetupRoot
        $trigger   = New-ScheduledTaskTrigger -AtLogOn -User $user
        $principal = New-ScheduledTaskPrincipal -UserId $user -LogonType Interactive -RunLevel Limited
        $settings  = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
            -ExecutionTimeLimit ([TimeSpan]::Zero) -MultipleInstances IgnoreNew

        Register-ScheduledTask -TaskName $StartupTaskName -Action $action -Trigger $trigger `
            -Principal $principal -Settings $settings -Force -ErrorAction Stop | Out-Null

        if (Test-Path -LiteralPath $shortcut) { Remove-Item -LiteralPath $shortcut -Force }
        Add-Result "startup registration" "Ok" "scheduled task '$StartupTaskName'"
        return
    } catch {
        Write-Log "Could not create the scheduled task ($($_.Exception.Message)). Using the Startup folder instead." "WARN"
    }

    try {
        $shell = New-Object -ComObject WScript.Shell
        $link = $shell.CreateShortcut($shortcut)
        $link.TargetPath       = $exe
        $link.Arguments        = $taskArgs
        $link.WorkingDirectory = $DevSetupRoot
        $link.WindowStyle      = 7   # minimized
        $link.Save()
        Add-Result "startup registration" "Ok" "shortcut $shortcut"
    } catch {
        Add-Result "startup registration" "Failed" "$($_.Exception.Message)"
    }
}

# ---------------------------------------------------------------- main

$logFile = Start-DevLog "setup" -Transcript
if ($DryRun) { Write-Log "Dry run: nothing will be installed or changed." }

Sync-Path
$haveScoop = Install-Scoop

if ($haveScoop) {
    $installed = Get-ScoopInstalled
    # git must be installed before adding buckets (scoop clones buckets with git)
    Install-ScoopPackage "git" $installed

    $buckets = @(scoop bucket list 6>$null 2>$null | ForEach-Object { $_.Name })
    foreach ($row in Get-ConfigRows "scoop_buckets") {
        Install-ScoopBucket $row.Config $row.Value $buckets
    }

    $installed = Get-ScoopInstalled
    foreach ($row in Get-ConfigRows "scoop_packages") {
        if ($row.Config -eq "git") { continue }
        Install-ScoopPackage $row.Config $installed
    }
} elseif ($DryRun) {
    foreach ($row in Get-ConfigRows "scoop_packages") { Add-Result "scoop: $($row.Config)" "DryRun" "would install" }
} else {
    Write-Log "Skipping scoop buckets and packages: scoop is not available." "ERROR"
}

foreach ($row in Get-ConfigRows "winget_packages") {
    Install-WingetPackage $row.Config $row.Value
}

foreach ($row in Get-ConfigRows "zip_installs") {
    Install-ZipPackage $row.Config $row.Value (Expand-ConfigPath $row.Args)
}

foreach ($row in Get-ConfigRows "user_path") {
    Add-UserPath $row.Config (Expand-ConfigPath $row.Value)
}

foreach ($row in Get-ConfigRows "post_install") {
    Invoke-PostInstall $row.Config $row.Value
}

foreach ($row in Get-ConfigRows "setup_scripts") {
    Invoke-SetupScript $row.Config (Expand-ConfigPath $row.Value) (Expand-ConfigArgs $row.Args)
}

if (Test-ConfigTrue "setup_settings" "register_startup" $true) {
    Register-Startup
}

Write-Log "========================================"
Write-Log "Setup finished: $(Get-ResultSummary)"
Write-Log "Log: $logFile"
Stop-Transcript | Out-Null

if (Test-AnyFailed) { exit 1 }
