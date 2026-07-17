@echo off
setlocal
cd /d "%~dp0"
echo Running Episode 01 read-only preflight...
echo This does not install WSL, change Windows features, or restart the PC.
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\01-wsl-helper.ps1" -Mode Preflight -OpenFolder
echo.
echo If a result folder opened, send PUBLIC-REPORT.md to Codex.
echo Do not send the raw folder.
pause
endlocal
