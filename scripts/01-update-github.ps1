[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

if (-not (Get-Command git.exe -ErrorAction SilentlyContinue)) {
    throw 'git.exe was not found. Install Git for Windows first.'
}

if (-not (Test-Path -LiteralPath (Join-Path $repoRoot '.git'))) {
    throw 'This folder is not the existing Git repository. Copy the update over the published repository folder and run again.'
}

# Trust only this exact repository for this process. Global Git settings are not changed.
$existingGitConfigCount = 0
[void][int]::TryParse($env:GIT_CONFIG_COUNT, [ref]$existingGitConfigCount)
Set-Item -Path "Env:GIT_CONFIG_KEY_$existingGitConfigCount" -Value 'safe.directory'
Set-Item -Path "Env:GIT_CONFIG_VALUE_$existingGitConfigCount" -Value $repoRoot
$env:GIT_CONFIG_COUNT = [string]($existingGitConfigCount + 1)

$insideWorkTree = git.exe rev-parse --is-inside-work-tree 2>$null
if ($LASTEXITCODE -ne 0 -or ([string]$insideWorkTree).Trim() -ne 'true') {
    throw 'The current folder is not a valid Git working tree.'
}

Write-Host 'This update will revise the Episode 01 documents and remove three obsolete internal files.' -ForegroundColor Yellow
$answer = Read-Host 'Type UPDATE to prepare the changes'
if ($answer -cne 'UPDATE') {
    Write-Host 'Cancelled. No file was removed and nothing was pushed.' -ForegroundColor Cyan
    exit 0
}

# Clear any files staged by an earlier or incorrect publication attempt.
# This changes only the staging area and does not delete working files.
git.exe reset --quiet HEAD --
if ($LASTEXITCODE -ne 0) {
    throw 'Unable to clear the previous staging area. No file was removed or pushed.'
}

$obsoletePaths = @(
    'AGENTS.md',
    'prompts/01-review-preflight.md',
    'prompts/01-finalize-lesson.md'
)

foreach ($relativePath in $obsoletePaths) {
    git.exe rm -f --ignore-unmatch -- $relativePath
    if ($LASTEXITCODE -ne 0) {
        throw "Unable to remove obsolete tracked file: $relativePath"
    }

    $fullPath = Join-Path $repoRoot $relativePath
    if (Test-Path -LiteralPath $fullPath) {
        Remove-Item -LiteralPath $fullPath -Force
    }
}

$promptDirectory = Join-Path $repoRoot 'prompts'
if ((Test-Path -LiteralPath $promptDirectory) -and
    -not (Get-ChildItem -LiteralPath $promptDirectory -Force)) {
    Remove-Item -LiteralPath $promptDirectory -Force
}

git.exe add --all
if ($LASTEXITCODE -ne 0) {
    throw 'git add failed. Nothing was committed or pushed.'
}

git.exe diff --cached --check
if ($LASTEXITCODE -ne 0) {
    throw 'Git found whitespace or conflict-marker errors. Nothing was committed or pushed.'
}

$status = git.exe status --short
if ($LASTEXITCODE -ne 0) {
    throw 'git status failed. Nothing was committed or pushed.'
}

if (-not $status) {
    Write-Host 'No update is needed. The working tree already matches this package.' -ForegroundColor Green
    exit 0
}

Write-Host ''
Write-Host 'Changes ready to publish:' -ForegroundColor Cyan
$status | ForEach-Object { Write-Host $_ }
Write-Host ''

$publish = Read-Host 'Type PUBLISH to commit and push these changes'
if ($publish -cne 'PUBLISH') {
    Write-Host 'Cancelled before commit and push. The changes remain staged locally.' -ForegroundColor Cyan
    exit 0
}

git.exe commit -m 'docs: revise episode 01 beginner WSL guide'
if ($LASTEXITCODE -ne 0) {
    throw 'git commit failed. Check Git user.name and user.email.'
}

git.exe push
if ($LASTEXITCODE -ne 0) {
    throw 'git push failed. The commit remains safely stored in the local repository.'
}

Write-Host 'GitHub update completed.' -ForegroundColor Green
