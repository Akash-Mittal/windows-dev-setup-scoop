# Requires administrator privileges to run
# This script will attempt to elevate itself if not already running as administrator.

# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Attempting to elevate script to Administrator privileges..."
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}

# Set execution policy for the current session to allow scripts to run
Set-ExecutionPolicy Bypass -Scope Process -Force

Write-Host "Running defualt-file-extension.notepad.ps1 with Administrator privileges."

$extensions = @(
    ".txt",".log",".cfg",".conf",".ini",".env",".properties",
    ".toml",".yaml",".yml",".json",".jsonc",".xml",".xsd",
    ".csv",".tsv",".md",".rst",".adoc",".nfo",

    ".html",".htm",".xhtml",".css",".scss",".sass",".less",
    ".js",".mjs",".cjs",".jsx",".ts",".tsx",".vue",".svelte",

    ".py",".java",".kt",".kts",".groovy",".scala",
    ".c",".h",".cpp",".hpp",".cc",".hh",
    ".cs",".fs",".vb",
    ".go",".rs",".swift",".m",".mm",
    ".rb",".php",".pl",".lua",".dart",".nim",".zig",

    ".sh",".bash",".zsh",".fish",
    ".ps1",".psm1",".psd1",
    ".bat",".cmd",".pub",

    ".sql",".graphql",".gql",
    ".dockerfile",".dockerignore",
    ".gitignore",".gitattributes",".gitmodules",
    ".tf",".tfvars",".hcl",
    ".yaml.tmpl",".yml.tmpl",

    ".gradle",".pom",".sbt",
    ".makefile",".mk",
    ".cmake",".cmake.in",
    ".npmrc",".yarnrc",".pnpmfile",

    ".editorconfig",".prettierrc",".eslintrc",
    ".stylelintrc",".babelrc",
    ".vimrc",".zshrc",".bashrc",".profile"
)

$notepadpp = "$env:USERPROFILE\scoop\apps\notepadplusplus\current\notepad++.exe"

if (-not (Test-Path $notepadpp)) {
    Write-Error "Notepad++ not found at: $notepadpp. Cannot set file associations."
    Exit 1
}

$extList = $extensions | Where-Object { $_ -and $_.StartsWith(".") } | ForEach-Object { $_.ToLowerInvariant() } | Sort-Object -Unique

Write-Host "Setting file type for NotepadPP.File..."
$ftypeCmd = "ftype NotepadPP.File=`"$notepadpp`" `"%1`""
cmd /c $ftypeCmd | Out-Null

Write-Host "Associating extensions with Notepad++..."
foreach ($ext in $extList) {
    $assocCmd = "assoc $ext=NotepadPP.File"
    cmd /c $assocCmd | Out-Null
}

Write-Host "File associations with Notepad++ completed."
cmd /c "ftype NotepadPP.File"

# --- Notepad++ File Associations ---
$notepadAssocScript = Join-Path $PSScriptRoot "defualt-file-extension.notepad.ps1"
if (Test-Path $notepadAssocScript) {
    Write-Host "Running Notepad++ file association script..."
    # The script itself handles elevation, so we just execute it.
    & "$notepadAssocScript"
    Write-Host "Notepad++ file association script finished."
} else {
    Write-Warning "Notepad++ file association script not found at '$notepadAssocScript'. Skipping file associations."
}

Read-Host "Press Enter to exit..."