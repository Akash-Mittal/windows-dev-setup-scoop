# PowerShell script to open Google Chrome with the "Personal" profile and specific tabs.

$CHROME = "chrome.exe"
$PROFILE = "Personal"

# Open default tabs for Personal profile
Write-Host "Opening Chrome with profile '$PROFILE' and specified tabs..."

Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "--new-window", "https://calendar.google.com/calendar/u/0/r"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://mail.google.com/mail/u/0/#inbox"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://mail.google.com/mail/u/1/#inbox"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://translate.google.com/?sl=es&tl=en&op=translate"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://www.google.com/maps"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://www.idealista.com/en/usuario/tus-alertas"

Write-Host "Chrome startup script for Personal profile completed."
