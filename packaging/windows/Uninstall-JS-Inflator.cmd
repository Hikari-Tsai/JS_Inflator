@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Uninstall-JS-Inflator.ps1"
if errorlevel 1 echo Uninstall failed. Review the message above.
pause
