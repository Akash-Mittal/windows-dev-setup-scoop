set "CHROME=chrome.exe"
set "PROFILE=Personal"

rem Open default tabs for Personal profile
start "" "%CHROME%" --profile-directory="%PROFILE%" --new-window "https://calendar.google.com/calendar/u/0/r"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://mail.google.com/mail/u/0/#inbox"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://mail.google.com/mail/u/1/#inbox"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://translate.google.com/?sl=es&tl=en&op=translate"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://www.google.com/maps"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://www.idealista.com/en/usuario/tus-alertas"
