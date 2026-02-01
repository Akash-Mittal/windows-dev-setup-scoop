@echo off
setlocal

echo === Starting update process ===
echo Time: %date% %time%

set "REPO_DIR=%~1"
if "%REPO_DIR%"=="" set "REPO_DIR=%~dp0"
for %%i in ("%REPO_DIR%") do set "REPO_DIR=%%~fi"

echo.
echo Switching to repo: %REPO_DIR%
cd /d "%REPO_DIR%" || (
  echo ❌ Repo directory not found: %REPO_DIR%
  exit /b 1
)

if not exist ".git" (
  echo ❌ Not a git repository: %CD%
  exit /b 1
)

echo.
echo Fetching remote updates...
git fetch
if %errorlevel% neq 0 (
  echo ❌ git fetch failed with error code %errorlevel%
  exit /b %errorlevel%
)
echo ✅ Git fetch complete.

echo.
echo Pulling latest changes from Git...
git pull
if %errorlevel% neq 0 (
  echo ❌ git pull failed with error code %errorlevel%
  exit /b %errorlevel%
)
echo ✅ Git pull complete.

mvn clean install -Denv=release

echo.
echo === Update complete ===
echo Time: %date% %time%

pause