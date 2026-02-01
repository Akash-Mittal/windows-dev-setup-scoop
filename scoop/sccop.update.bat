@echo off
setlocal

echo ===============================
echo Updating Scoop packages
echo Time: %date% %time%
echo ===============================

REM --- Check if Scoop exists ---
where scoop >nul 2>&1
if %errorlevel% neq 0 (
  echo Scoop not found. Skipping update.
  exit /b 0
)

REM --- Update Scoop itself ---
echo Updating Scoop...
scoop update
if %errorlevel% neq 0 (
  echo Warning: scoop update failed.
)

REM --- Update all installed packages ---
echo Updating all Scoop packages...
scoop update *
if %errorlevel% neq 0 (
  echo Warning: some packages failed to update.
)

echo ===============================
echo Scoop update finished
echo ===============================

endlocal
exit /b 0
