
@echo off
echo Cleaning temporary files... 🧹

:: 1. Clear user temp folder
echo Deleting files in %TEMP%...
del /f /s /q "%TEMP%\*"
for /d %%p in ("%TEMP%\*") do rmdir "%%p" /s /q

:: 2. Clear Windows temp folder
echo Deleting files in C:\Windows\Temp...
del /f /s /q "C:\Windows\Temp\*"
for /d %%p in ("C:\Windows\Temp\*") do rmdir "%%p" /s /q

echo ✅ Temp cleanup complete!

