if (Get-Command scoop.cmd -ErrorAction SilentlyContinue) {
    scoop update
    scoop update *
}
cd