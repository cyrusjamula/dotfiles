#Requires -Version 5.1
$ErrorActionPreference = "Stop"

Write-Host "Installing WinGet..." -ForegroundColor Green

if (-not (Get-Command Add-AppxPackage -ErrorAction SilentlyContinue)) {
    Write-Host "This installer requires Windows PowerShell with AppX support." -ForegroundColor Yellow
    exit 0
}

if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "WinGet is already installed." -ForegroundColor Green
    winget --version
    exit 0
}

$TempPath = Join-Path $env:TEMP "Microsoft.DesktopAppInstaller.msixbundle"
$WingetBundleUrl = "https://aka.ms/getwinget"

Write-Host "Downloading WinGet package from $WingetBundleUrl" -ForegroundColor Blue
Invoke-WebRequest -Uri $WingetBundleUrl -OutFile $TempPath -UseBasicParsing

Write-Host "Installing package..." -ForegroundColor Blue
Add-AppxPackage -Path $TempPath

if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "WinGet installed successfully." -ForegroundColor Green
    winget --version
    Write-Host "If this shell does not resolve winget yet, open a new terminal session." -ForegroundColor Yellow
} else {
    Write-Host "WinGet installation command completed, but winget is not available in this session." -ForegroundColor Yellow
    Write-Host "Try opening a new terminal. If needed, install App Installer from Microsoft Store." -ForegroundColor Yellow
}
