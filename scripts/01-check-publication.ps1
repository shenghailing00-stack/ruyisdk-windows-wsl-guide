[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$required = @(
    'docs\01-install-wsl2.md',
    'video-scripts\01-install-wsl2.md',
    'video-scripts\01-install-wsl2.srt',
    'assets\01-install-wsl2\01-winver.png',
    'assets\01-install-wsl2\02-wsl-ubuntu-environment.png',
    'test-records\environment-baseline.md',
    'test-records\episode-01\2026-07-17-verified\PUBLIC-REPORT.md',
    'publishing\01-forum-post.md',
    'publishing\01-video-description.md',
    'publishing\01-social-posts.md'
)

$failed = $false
foreach ($path in $required) {
    if (-not (Test-Path -LiteralPath (Join-Path $repoRoot $path))) {
        Write-Host "MISSING: $path" -ForegroundColor Red
        $failed = $true
    }
}

$publicationRoots = @('docs', 'video-scripts', 'test-records', 'publishing')
$textFiles = foreach ($directory in $publicationRoots) {
    Get-ChildItem -LiteralPath (Join-Path $repoRoot $directory) -Recurse -File |
        Where-Object { $_.Extension -in @('.md', '.srt', '.txt') }
}

$riskPatterns = @(
    'TODO\(EVIDENCE\)',
    '(?i)C:\\Users\\(?!<WindowsUser>)',
    '(?i)/home/(?!<LinuxUser>)',
    '(?i)(token|password|secret)\s*[:=]\s*[^<\s]'
)

foreach ($pattern in $riskPatterns) {
    $matches = $textFiles | Select-String -Pattern $pattern
    if ($matches) {
        Write-Host "REVIEW pattern: $pattern" -ForegroundColor Yellow
        $matches | ForEach-Object { Write-Host "  $($_.Path):$($_.LineNumber)" }
        if ($pattern -eq 'TODO\(EVIDENCE\)') { $failed = $true }
    }
}

if (Get-Command git.exe -ErrorAction SilentlyContinue) {
    $insideWorkTree = git.exe rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -eq 0 -and ([string]$insideWorkTree).Trim() -eq 'true') {
        git.exe diff --check
        if ($LASTEXITCODE -ne 0) { $failed = $true }
    }
}

if ($failed) {
    Write-Host 'Publication check failed.' -ForegroundColor Red
    exit 1
}

Write-Host 'Publication check passed. Review link placeholders before posting.' -ForegroundColor Green
