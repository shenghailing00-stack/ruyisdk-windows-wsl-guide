@echo off
setlocal
cd /d "%~dp0"
echo This action updates the existing GitHub repository after explicit confirmation.
echo Copy this package over the existing local repository before continuing.
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\01-update-github.ps1"
echo.
pause
