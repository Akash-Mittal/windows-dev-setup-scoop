# PowerShell script to open Google Chrome with the "Personal" profile for blogging tasks and specific tabs.

$CHROME = "chrome.exe"
$PROFILE = "Personal"

# Open default tabs for Personal profile (Blogging)
Write-Host "Opening Chrome with profile '$PROFILE' for blogging tasks and specified tabs..."

Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "--new-window", "https://my.bluehost.in/hosting/app?lil=1#/"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://cpanel-sh117.webhostingservices.com/cpsess6564980317/frontend/jupiter/filemanager/index.html"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://cpanel-sh117.webhostingservices.com/cpsess6564980317/frontend/jupiter/index.html"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://wordpress.com/sites/brainprintout.wordpress.com"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://brainprintout.wordpress.com/"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://nicaindia.wordpress.com/"

Write-Host "Chrome startup script for Personal (Blogging) profile completed."
