[CmdletBinding()]
param()

$Host.UI.RawUI.WindowTitle = 'Ubuntu 24.04 evidence'
$env:WSL_UTF8 = '1'
try {
    $utf8NoBom = New-Object System.Text.UTF8Encoding -ArgumentList $false
    [Console]::OutputEncoding = $utf8NoBom
}
catch {}

Set-Location $env:SystemRoot
Write-Host '=== Ubuntu release ===' -ForegroundColor Cyan
wsl.exe -d Ubuntu-24.04 --cd / -- cat /etc/os-release
Write-Host ''
Write-Host '=== Kernel and architecture ===' -ForegroundColor Cyan
wsl.exe -d Ubuntu-24.04 --cd / -- uname -mr
Write-Host ''
Read-Host 'Capture this window, then press Enter to close'
