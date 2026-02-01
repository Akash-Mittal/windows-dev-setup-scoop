
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
    ".bat",".cmd",

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
    throw "Notepad++ not found at: $notepadpp"
}

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "Run this PowerShell as Administrator."
}

$extList = $extensions | Where-Object { $_ -and $_.StartsWith(".") } | ForEach-Object { $_.ToLowerInvariant() } | Sort-Object -Unique

$ftypeCmd = "ftype NotepadPP.File=`"$notepadpp`" `"%1`""
cmd /c $ftypeCmd | Out-Null

foreach ($ext in $extList) {
    $assocCmd = "assoc $ext=NotepadPP.File"
    cmd /c $assocCmd | Out-Null
}

cmd /c "ftype NotepadPP.File"
