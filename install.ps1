#Requires -Version 5.1
$ErrorActionPreference = "Stop"

# Main dotfiles installation script for PowerShell

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Installing dotfiles from: $DotfilesDir" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# Install git dotfiles
$GitInstaller = Join-Path $DotfilesDir "git\install.ps1"
if (Test-Path $GitInstaller) {
    Write-Host "Installing Git configuration..." -ForegroundColor Blue
    Push-Location (Join-Path $DotfilesDir "git")
    try { & .\install.ps1 } finally { Pop-Location }
    Write-Host ""
}

# Install shell dotfiles (when they exist)
$ShellInstaller = Join-Path $DotfilesDir "shell\install.ps1"
if (Test-Path $ShellInstaller) {
    Write-Host "Installing Shell configuration..." -ForegroundColor Blue
    Push-Location (Join-Path $DotfilesDir "shell")
    try { & .\install.ps1 } finally { Pop-Location }
    Write-Host ""
}

# Install Oh My Posh
$OhMyPoshInstaller = Join-Path $DotfilesDir "ohmyposh\install.ps1"
if (Test-Path $OhMyPoshInstaller) {
    Write-Host "Installing Oh My Posh configuration..." -ForegroundColor Blue
    Push-Location (Join-Path $DotfilesDir "ohmyposh")
    try { & .\install.ps1 } finally { Pop-Location }
    Write-Host ""
}

Write-Host "Dotfiles installation complete!" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Green
