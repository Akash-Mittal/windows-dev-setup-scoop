git pull
git fetch
set "WORK_DIR=%~1"
cd /d "%WORK_DIR%"
docker compose down --remove-orphans
echo Removing any existing containers with conflicting names...
docker rm -f xcp-local-mongo-database-container 2>NUL
docker rm -f xcp-local-activemq 2>NUL
docker rm -f xcp-local-frontend 2>NUL
docker compose up --build -d
