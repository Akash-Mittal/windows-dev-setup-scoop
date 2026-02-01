# PowerShell script to open Google Chrome with the "Personal" profile for banking tasks and specific tabs.

$CHROME = "chrome.exe"
$PROFILE = "Personal"

# Open default tabs for Personal profile (Banking)
Write-Host "Opening Chrome with profile '$PROFILE' for banking tasks and specified tabs..."

Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "--new-window", "https://netbanking.hdfcbank.com/netbanking/"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://retailnetbanking.icici.bank.in/login-page"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://kunden.commerzbank.de/startpage/startpage"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://meine.deutsche-bank.de/#/banking/financial-overview"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://particulares.bancosantander.es/oneweb/global-position"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://app.n26.com/feed"
Start-Process -FilePath $CHROME -ArgumentList "--profile-directory=`"$PROFILE`"", "https://app.revolut.com/home"

Write-Host "Chrome startup script for Personal (Banking) profile completed."
