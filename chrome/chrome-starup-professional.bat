set "CHROME=chrome.exe"
set "PROFILE=Professional"

rem Open default tabs for Professional profile
start "" "%CHROME%" --profile-directory="%PROFILE%" --new-window "https://confluence.media-saturn.com/spaces/~mittala/overview"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://jira.media-saturn.com/secure/RapidBoard.jspa?rapidView=4538#"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://console.cloud.google.com/run/overview?project=mms-xcp-xcp-p"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://github.com/MediaMarktSaturn/xcp-posting"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://cloud.mongodb.com/v2/632db29faf84ef7bf684e4ab#/clusters"
start "" "%CHROME%" --profile-directory="%PROFILE%" "https://xcp-prod-frontend-swzlilrgcq-ez.a.run.app/"
