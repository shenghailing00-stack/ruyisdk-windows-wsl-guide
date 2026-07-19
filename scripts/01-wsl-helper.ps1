[CmdletBinding()]
param(
    [ValidateSet('Preflight', 'Install', 'Verify')]
    [string]$Mode = 'Preflight',

    [string]$Distro = 'Ubuntu-24.04',

    [switch]$OpenFolder,

    [switch]$Yes
)

$ErrorActionPreference = 'Continue'
$ProgressPreference = 'SilentlyContinue'

# Recent WSL releases can emit UTF-16 when stdout is redirected. Request UTF-8
# explicitly so reports remain readable in Windows PowerShell 5.1.
try {
    $utf8NoBom = New-Object System.Text.UTF8Encoding -ArgumentList $false
    [Console]::OutputEncoding = $utf8NoBom
    $OutputEncoding = $utf8NoBom
    $env:WSL_UTF8 = '1'
}
catch {
    # Continue with the host defaults if the console encoding is unavailable.
}

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-RepoRoot {
    $scriptDir = Split-Path -Parent $PSCommandPath
    return Split-Path -Parent $scriptDir
}

function New-RecordDirectory {
    param([string]$CurrentMode)

    $root = Get-RepoRoot
    $stamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
    $dir = Join-Path $root "test-records\episode-01\${stamp}-${CurrentMode}"
    $raw = Join-Path $dir 'raw'
    New-Item -ItemType Directory -Path $raw -Force | Out-Null
    return @{ Root = $dir; Raw = $raw }
}

function Write-Section {
    param([string]$Title)
    Write-Host ''
    Write-Host ('=' * 72) -ForegroundColor DarkCyan
    Write-Host $Title -ForegroundColor Cyan
    Write-Host ('=' * 72) -ForegroundColor DarkCyan
}

function Save-Text {
    param(
        [string]$Path,
        [object]$Value
    )
    $text = $Value | Out-String -Width 240
    $text = $text.Replace([string][char]0, '')
    Set-Content -LiteralPath $Path -Value $text -Encoding UTF8
}

function Invoke-AndCapture {
    param(
        [string]$Label,
        [scriptblock]$Command,
        [string]$OutputPath
    )

    Write-Host "> $Label" -ForegroundColor Yellow
    try {
        $result = @(& $Command 2>&1) | ForEach-Object {
            if ($_ -is [System.Management.Automation.ErrorRecord]) {
                $_.Exception.Message
            }
            else {
                $_
            }
        }
        Save-Text -Path $OutputPath -Value $result
        $result | Out-Host
        return $result
    }
    catch {
        $message = "ERROR: $($_.Exception.Message)"
        Save-Text -Path $OutputPath -Value $message
        Write-Warning $message
        return $message
    }
}

function Protect-PublicText {
    param([string]$Text)

    $protected = $Text
    $values = @(
        $env:USERNAME,
        $env:COMPUTERNAME,
        $env:USERPROFILE,
        [Environment]::UserName
    ) | Where-Object { $_ -and $_.Length -ge 2 } | Sort-Object -Unique

    foreach ($value in $values) {
        $protected = $protected.Replace($value, '<REDACTED>')
    }

    $protected = $protected -replace '(?i)C:\\Users\\[^\\\s]+', 'C:\Users\<WindowsUser>'
    $protected = $protected -replace '(?i)/home/[^/\s]+', '/home/<LinuxUser>'
    $protected = $protected -replace "(?i)[A-Z]:\\[^\r\n']+", '<WindowsPath>'
    return $protected
}

function Get-WindowsSummary {
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        return [ordered]@{
            Caption = $os.Caption
            Version = $os.Version
            BuildNumber = $os.BuildNumber
            Architecture = $os.OSArchitecture
        }
    }
    catch {
        return [ordered]@{
            Caption = 'Unavailable'
            Version = [Environment]::OSVersion.Version.ToString()
            BuildNumber = [Environment]::OSVersion.Version.Build
            Architecture = $env:PROCESSOR_ARCHITECTURE
        }
    }
}

function Get-VirtualizationSummary {
    $result = [ordered]@{}
    try {
        $computer = Get-CimInstance Win32_ComputerSystem
        $result.HypervisorPresent = $computer.HypervisorPresent
    }
    catch {
        $result.HypervisorPresent = 'Unavailable'
    }

    try {
        $processor = Get-CimInstance Win32_Processor | Select-Object -First 1
        $result.VirtualizationFirmwareEnabled = $processor.VirtualizationFirmwareEnabled
        $result.VMMonitorModeExtensions = $processor.VMMonitorModeExtensions
        $result.SecondLevelAddressTranslationExtensions = $processor.SecondLevelAddressTranslationExtensions
    }
    catch {
        $result.VirtualizationFirmwareEnabled = 'Unavailable'
        $result.VMMonitorModeExtensions = 'Unavailable'
        $result.SecondLevelAddressTranslationExtensions = 'Unavailable'
    }
    return $result
}

function Write-PublicReport {
    param(
        [hashtable]$Record,
        [string]$CurrentMode,
        [System.Collections.IDictionary]$Windows,
        [System.Collections.IDictionary]$Virtualization
    )

    $rawFiles = Get-ChildItem -LiteralPath $Record.Raw -File -ErrorAction SilentlyContinue
    $rawText = foreach ($file in $rawFiles) {
        "### $($file.BaseName)`n`n~~~text`n$(Get-Content -LiteralPath $file.FullName -Raw)`n~~~"
    }

    $report = @"
# Episode 01 public test report

- Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')
- Mode: $CurrentMode
- Administrator: $(Test-IsAdministrator)
- Windows: $($Windows.Caption)
- Windows version: $($Windows.Version)
- Windows build: $($Windows.BuildNumber)
- Architecture: $($Windows.Architecture)
- Hypervisor present: $($Virtualization.HypervisorPresent)
- Virtualization firmware enabled: $($Virtualization.VirtualizationFirmwareEnabled)
- VM monitor extensions: $($Virtualization.VMMonitorModeExtensions)
- SLAT extensions: $($Virtualization.SecondLevelAddressTranslationExtensions)

## Captured command output

$($rawText -join "`n`n")

## Evidence status

- [ ] Screenshot 01-winver.png reviewed
- [ ] Screenshot 02-wsl-install.png reviewed
- [ ] Screenshot 03-ubuntu-first-run.png reviewed
- [ ] Screenshot 04-wsl-list-verbose.png reviewed

## Privacy review

- [ ] No Windows username or computer name
- [ ] No Linux username or home directory
- [ ] No IP address, token, proxy URL, or unrelated notification
"@

    $report = Protect-PublicText -Text $report
    $path = Join-Path $Record.Root 'PUBLIC-REPORT.md'
    Set-Content -LiteralPath $path -Value $report -Encoding UTF8
    return $path
}

function Invoke-Preflight {
    $record = New-RecordDirectory -CurrentMode 'preflight'
    $windows = Get-WindowsSummary
    $virtualization = Get-VirtualizationSummary

    Write-Section 'Windows and WSL read-only preflight'
    $windows | Format-List | Out-Host
    $virtualization | Format-List | Out-Host

    $build = 0
    $buildParsed = [int]::TryParse([string]$windows.BuildNumber, [ref]$build)
    if (-not $buildParsed) { $build = 0 }
    if ($build -ge 19041) {
        Write-Host 'PASS: Windows build supports the one-command WSL install flow.' -ForegroundColor Green
    }
    else {
        Write-Warning 'BLOCKER: Windows build is below 19041 or could not be detected.'
    }

    if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
        Invoke-AndCapture 'wsl.exe --version' { wsl.exe --version } (Join-Path $record.Raw 'wsl-version.txt') | Out-Null
        Invoke-AndCapture 'wsl.exe --status' { wsl.exe --status } (Join-Path $record.Raw 'wsl-status.txt') | Out-Null
        Invoke-AndCapture 'wsl.exe --list --verbose' { wsl.exe --list --verbose } (Join-Path $record.Raw 'wsl-list-verbose.txt') | Out-Null
        Invoke-AndCapture 'wsl.exe --list --online' { wsl.exe --list --online } (Join-Path $record.Raw 'wsl-list-online.txt') | Out-Null
    }
    else {
        Save-Text (Join-Path $record.Raw 'wsl-command.txt') 'wsl.exe was not found.'
        Write-Warning 'wsl.exe was not found. The install stage may need the Windows optional feature path.'
    }

    $public = Write-PublicReport -Record $record -CurrentMode 'Preflight' -Windows $windows -Virtualization $virtualization
    Write-Host "Public report: $public" -ForegroundColor Green
    Write-Host 'Keep PUBLIC-REPORT.md for review. Do not publish the raw folder.' -ForegroundColor Cyan

    if ($OpenFolder) {
        Start-Process explorer.exe -ArgumentList ('"{0}"' -f $record.Root)
    }
}

function Invoke-Install {
    if (-not (Test-IsAdministrator)) {
        Write-Host 'Administrator rights are required. Opening a UAC confirmation window...' -ForegroundColor Yellow
        $arguments = @(
            '-NoProfile',
            '-ExecutionPolicy', 'Bypass',
            '-File', ('"{0}"' -f $PSCommandPath),
            '-Mode', 'Install',
            '-Distro', $Distro
        )
        if ($Yes) { $arguments += '-Yes' }
        Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments
        return
    }

    Write-Section "Install WSL 2 and $Distro"
    Write-Host 'This stage changes Windows optional features and may require a restart.' -ForegroundColor Yellow

    if (-not $Yes) {
        $answer = Read-Host 'Type INSTALL to continue'
        if ($answer -cne 'INSTALL') {
            Write-Host 'Cancelled. No install command was run.' -ForegroundColor Cyan
            return
        }
    }

    $record = New-RecordDirectory -CurrentMode 'install'
    $windows = Get-WindowsSummary
    $virtualization = Get-VirtualizationSummary

    Invoke-AndCapture 'wsl.exe --set-default-version 2' {
        wsl.exe --set-default-version 2
    } (Join-Path $record.Raw 'set-default-version.txt') | Out-Null

    Invoke-AndCapture "wsl.exe --install -d $Distro" {
        wsl.exe --install -d $Distro
    } (Join-Path $record.Raw 'wsl-install.txt') | Out-Null

    $public = Write-PublicReport -Record $record -CurrentMode 'Install' -Windows $windows -Virtualization $virtualization
    Write-Host "Install report: $public" -ForegroundColor Green
    Write-Host 'Restart Windows if requested, launch Ubuntu once, create the Linux user, then run Verify.' -ForegroundColor Cyan
    Write-Host "If download is stuck at 0.0%, the documented fallback is: wsl.exe --install --web-download -d $Distro" -ForegroundColor Yellow
}

function Invoke-Verify {
    $record = New-RecordDirectory -CurrentMode 'verify'
    $windows = Get-WindowsSummary
    $virtualization = Get-VirtualizationSummary

    Write-Section "Verify WSL 2 and $Distro"
    Invoke-AndCapture 'wsl.exe --version' { wsl.exe --version } (Join-Path $record.Raw 'wsl-version.txt') | Out-Null
    Invoke-AndCapture 'wsl.exe --status' { wsl.exe --status } (Join-Path $record.Raw 'wsl-status.txt') | Out-Null
    Invoke-AndCapture 'wsl.exe --list --verbose' { wsl.exe --list --verbose } (Join-Path $record.Raw 'wsl-list-verbose.txt') | Out-Null
    $safeWindowsDirectory = $env:SystemRoot
    Invoke-AndCapture "Linux identity for $Distro" {
        # Launch from a local Windows system directory. WSL cannot translate
        # some removable/network drive working directories, even though the
        # target Linux distribution itself is healthy.
        Push-Location $safeWindowsDirectory
        try {
            wsl.exe -d $Distro --cd / -- cat /etc/os-release
            wsl.exe -d $Distro --cd / -- uname -mr
        }
        finally {
            Pop-Location
        }
    } (Join-Path $record.Raw 'linux-environment.txt') | Out-Null

    $public = Write-PublicReport -Record $record -CurrentMode 'Verify' -Windows $windows -Virtualization $virtualization
    Write-Host "Public report: $public" -ForegroundColor Green
    Write-Host 'Confirm that the distro VERSION column is 2, then capture the four required screenshots.' -ForegroundColor Cyan

    if ($OpenFolder) {
        Start-Process explorer.exe -ArgumentList ('"{0}"' -f $record.Root)
    }
}

switch ($Mode) {
    'Preflight' { Invoke-Preflight }
    'Install' { Invoke-Install }
    'Verify' { Invoke-Verify }
}
