[CmdletBinding()]
param()

$Host.UI.RawUI.WindowTitle = 'WSL 2 evidence'
$env:WSL_UTF8 = '1'
try {
    $utf8NoBom = New-Object System.Text.UTF8Encoding -ArgumentList $false
    [Console]::OutputEncoding = $utf8NoBom
}
catch {}

Set-Location $env:SystemRoot
Write-Host '=== WSL version ===' -ForegroundColor Cyan
wsl.exe --version
Write-Host ''
Write-Host '=== Installed distributions ===' -ForegroundColor Cyan
wsl.exe --list --verbose
Write-Host ''
Read-Host 'Capture this window, then press Enter to close'
