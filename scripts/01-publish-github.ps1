[CmdletBinding()]
param(
    [string]$RepoName = 'ruyisdk-windows-wsl-guide',

    [ValidateSet('public', 'private')]
    [string]$Visibility = 'public'
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

if (-not (Get-Command git.exe -ErrorAction SilentlyContinue)) {
    throw 'git.exe was not found. Install Git for Windows first.'
}
if (-not (Get-Command gh.exe -ErrorAction SilentlyContinue)) {
    throw 'gh.exe was not found. Install GitHub CLI and run: gh auth login'
}

gh.exe auth status
if ($LASTEXITCODE -ne 0) {
    throw 'GitHub CLI is not logged in. Run: gh auth login'
}

if (-not (Test-Path (Join-Path $repoRoot '.git'))) {
    git.exe init --initial-branch=main
    if ($LASTEXITCODE -ne 0) {
        throw 'git init failed. Confirm that this folder is writable.'
    }
}

$insideWorkTree = git.exe rev-parse --is-inside-work-tree 2>$null
if ($LASTEXITCODE -ne 0 -or ([string]$insideWorkTree).Trim() -ne 'true') {
    throw 'The tutorial folder is not a valid Git working tree.'
}

$gitName = git.exe config --get user.name
$gitEmail = git.exe config --get user.email
if (-not $gitName -or -not $gitEmail) {
    throw 'Git identity is missing. Configure git user.name and user.email first.'
}

git.exe add --all
if ($LASTEXITCODE -ne 0) {
    throw 'git add failed. No commit or remote publication was attempted.'
}

Write-Host ''
Write-Host 'Files prepared for the first commit:' -ForegroundColor Cyan
git.exe status --short
if ($LASTEXITCODE -ne 0) {
    throw 'git status failed. No commit or remote publication was attempted.'
}
Write-Host ''
Write-Host "Target repository: $RepoName ($Visibility)" -ForegroundColor Yellow
$answer = Read-Host 'Type PUBLISH to commit, create the GitHub repository, and push'
if ($answer -cne 'PUBLISH') {
    Write-Host 'Cancelled before commit or remote publication.' -ForegroundColor Cyan
    exit 0
}

git.exe commit -m 'docs: add Windows WSL RuyiSDK tutorial episode 01'
if ($LASTEXITCODE -ne 0) {
    throw 'git commit failed. Check your Git user.name and user.email settings.'
}

$visibilityFlag = "--$Visibility"
gh.exe repo create $RepoName $visibilityFlag --source . --remote origin --push
if ($LASTEXITCODE -ne 0) {
    throw 'GitHub repository creation or push failed. No retry was attempted.'
}

Write-Host 'GitHub publication completed.' -ForegroundColor Green
gh.exe repo view --web
