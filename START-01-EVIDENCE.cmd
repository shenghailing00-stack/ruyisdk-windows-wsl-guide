@echo off
setlocal
set WSL_UTF8=1

echo Opening three evidence windows...
echo 1. Windows version
echo 2. WSL version and distro list
echo 3. Ubuntu release, kernel, and architecture
echo.

start "Windows version evidence" winver.exe
start "WSL 2 evidence" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\01-show-wsl-evidence.ps1"
start "Ubuntu 24.04 evidence" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\01-show-ubuntu-evidence.ps1"

echo Use Win+Shift+S to capture each window after its output is complete.
echo See assets\01-install-wsl2\README.md for filenames and privacy checks.
pause
