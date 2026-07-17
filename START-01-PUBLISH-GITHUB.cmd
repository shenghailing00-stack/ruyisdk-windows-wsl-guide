@echo off
setlocal
cd /d "%~dp0"
echo This action can create a public GitHub repository after explicit confirmation.
echo It requires Git for Windows, GitHub CLI, and an authenticated gh session.
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\01-publish-github.ps1"
echo.
pause
