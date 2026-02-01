# PowerShell script to open Google Chrome with the "Professional" profile and specific tabs.

$CHROME = "chrome.exe"
$PROFILE = "Professional"

# Open default tabs for Professional profile
Write-Host "Opening Chrome with profile '$PROFILE' and specified tabs..."

Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "--new-window", "https://confluence.media-saturn.com/spaces/~mittala/overview"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://jira.media-saturn.com/secure/RapidBoard.jspa?rapidView=4538#"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://console.cloud.google.com/run/overview?project=mms-xcp-xcp-p"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://github.com/MediaMarktSaturn/xcp-posting"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://cloud.mongodb.com/v2/632db29faf84ef7bf684e4ab#/clusters"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://xcp-prod-frontend-swzlilrgcq-ez.a.run.app/"

Write-Host "Chrome startup script for Professional profile completed."
