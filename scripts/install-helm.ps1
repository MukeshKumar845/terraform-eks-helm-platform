<#
.SYNOPSIS
  Installs the Helm CLI for this repo (portable binary under .tools/helm, gitignored).

.DESCRIPTION
  - Does not require committing binaries.
  - Default: downloads Helm for Windows amd64 from get.helm.sh.
  - Optional: -UseWinget uses winget (may prompt for elevation / agreements).

.EXAMPLE
  .\scripts\install-helm.ps1
  $env:PATH = "$(Resolve-Path .\.tools\helm\windows-amd64);$env:PATH"
  helm version
#>
param(
    [string]$Version = "3.16.4",
    [switch]$UseWinget,
    [switch]$AddToUserPath
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$targetDir = Join-Path $repoRoot ".tools\helm\windows-amd64"
$helmExe = Join-Path $targetDir "helm.exe"

function Add-HelmToUserPath {
    param([string]$Dir)
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($userPath -split ';' | Where-Object { $_ -eq $Dir }) {
        Write-Host "User PATH already contains this directory." -ForegroundColor DarkGray
        return
    }
    $newPath = if ([string]::IsNullOrEmpty($userPath)) { $Dir } else { "$userPath;$Dir" }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Appended to user PATH (new shells only): $Dir" -ForegroundColor Green
}

function Test-HelmInPath {
    return [bool](Get-Command helm -ErrorAction SilentlyContinue)
}

if (Test-HelmInPath) {
    Write-Host "Helm is already on PATH:" -ForegroundColor Green
    helm version
    exit 0
}

if (Test-Path $helmExe) {
    Write-Host "Helm already installed at:" -ForegroundColor Green
    Write-Host "  $helmExe" -ForegroundColor Cyan
    Write-Host 'Add to this session: $env:PATH = "' -NoNewline
    Write-Host $targetDir -NoNewline -ForegroundColor Yellow
    Write-Host '";$env:PATH"'
    if ($AddToUserPath) { Add-HelmToUserPath $targetDir }
    & $helmExe version
    exit 0
}

if ($UseWinget) {
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $winget) {
        Write-Warning "winget not found. Install winget or run without -UseWinget (portable download)."
        exit 1
    }
    Write-Host "Installing Helm via winget (Helm.Helm)..." -ForegroundColor Green
    & winget install --id Helm.Helm -e --source winget --accept-package-agreements --accept-source-agreements
    if (Test-HelmInPath) {
        helm version
        exit 0
    }
    Write-Warning "winget finished but helm is not on PATH yet. Open a new terminal or use portable install."
    exit 1
}

New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
$zipName = "helm-v$Version-windows-amd64.zip"
$zipPath = Join-Path $env:TEMP $zipName
$url = "https://get.helm.sh/helm-v$Version-windows-amd64.zip"

Write-Host "Downloading Helm $Version ..." -ForegroundColor Green
Write-Host "  $url"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $url -OutFile $zipPath

Write-Host "Extracting to $targetDir ..." -ForegroundColor Green
Expand-Archive -Path $zipPath -DestinationPath $targetDir -Force
Remove-Item $zipPath -Force -ErrorAction SilentlyContinue

$nested = Join-Path $targetDir "windows-amd64\helm.exe"
if (Test-Path $nested) {
    Move-Item -Path $nested -Destination $helmExe -Force
    Remove-Item (Join-Path $targetDir "windows-amd64") -Recurse -Force -ErrorAction SilentlyContinue
}

if (-not (Test-Path $helmExe)) {
    Write-Error "helm.exe not found after extract. Check version exists: https://github.com/helm/helm/releases"
    exit 1
}

Write-Host "Installed:" -ForegroundColor Green
Write-Host "  $helmExe" -ForegroundColor Cyan
Write-Host ""
Write-Host "For this PowerShell session only, run:" -ForegroundColor Yellow
Write-Host ('  $env:PATH = "' + $targetDir + '";$env:PATH"')
Write-Host ""
Write-Host "Then: helm version" -ForegroundColor Yellow

if ($AddToUserPath) {
    Add-HelmToUserPath $targetDir
}

& $helmExe version
