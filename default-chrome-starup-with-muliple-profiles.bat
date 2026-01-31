rem Automote Chrome startup in windows with different profile with default bages

rem Close any existing Chrome (all profiles)
taskkill /IM chrome.exe /F >nul 2>&1

rem Brief pause to ensure processes exit cleanly
timeout /t 2 /nobreak >nul

@echo off
set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
set "PROFILE=Profile 2"

start "" "%CHROME%" --profile-directory="%PROFILE%" "https://calendar.google.com/calendar/u/0/r"

start "" "%CHROME%" --profile-directory="%PROFILE%" "https://mail.google.com/mail/u/0/#inbox"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://mail.google.com/mail/u/1/#inbox"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://translate.google.com/?sl=es&tl=en&op=translate"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://www.google.com/maps"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://www.idealista.com/en/usuario/tus-alertas"


rem Brief pause to ensure processes exit cleanly
timeout /t 2 /nobreak >nul

@echo off
set "PROFILE=Profile 5"
"

start "" "%CHROME%" --profile-directory="%PROFILE%" "https://confluence.media-saturn.com/spaces/~mittala/pages/620909573/Mittal+Akash%E2%80%99s+Home"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://jira.media-saturn.com/secure/RapidBoard.jspa?rapidView=4538#"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://console.cloud.google.com/run/overview?project=mms-xcp-xcp-p"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://github.com/MediaMarktSaturn/xcp-posting"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://cloud.mongodb.com/v2/632db29faf84ef7bf684e4ab#/clusters"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://xcp-prod-frontend-swzlilrgcq-ez.a.run.app/"
