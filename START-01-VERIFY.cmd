@echo off
setlocal
cd /d "%~dp0"
echo Verifying Ubuntu 24.04 on WSL 2. No administrator rights are required.
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\01-wsl-helper.ps1" -Mode Verify -Distro Ubuntu-24.04 -OpenFolder
echo.
if errorlevel 1 echo Verification returned an error. Keep this window open and take a screenshot.
pause
