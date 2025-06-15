# Git dotfiles installation script for PowerShell

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$GitDir = $DotfilesDir

Write-Host "Installing Git dotfiles..." -ForegroundColor Green

# Backup existing .gitconfig if it exists
$GitConfigPath = Join-Path $env:USERPROFILE ".gitconfig"
$BackupPath = Join-Path $env:USERPROFILE ".gitconfig.backup"

if (Test-Path $GitConfigPath) {
    Write-Host "Backing up existing .gitconfig to .gitconfig.backup" -ForegroundColor Yellow
    Copy-Item $GitConfigPath $BackupPath -Force
}

# Create symbolic link to our dotfiles .gitconfig
$SourcePath = Join-Path $GitDir ".gitconfig"
Write-Host "Creating link for .gitconfig..." -ForegroundColor Blue

try {
    # Try to create symbolic link (requires admin privileges or Developer Mode)
    New-Item -ItemType SymbolicLink -Path $GitConfigPath -Target $SourcePath -Force -ErrorAction Stop
    Write-Host "Symbolic link created successfully!" -ForegroundColor Green
}
catch {
    # If symbolic link fails, copy the file instead
    Write-Host "Symbolic link creation failed (no admin privileges), copying file instead..." -ForegroundColor Yellow
    Copy-Item $SourcePath $GitConfigPath -Force
    Write-Host "Note: File copied instead of linked. Changes to dotfiles won't auto-sync." -ForegroundColor Yellow
    Write-Host "To enable auto-sync, run as administrator or enable Developer Mode in Windows Settings." -ForegroundColor Yellow
}

Write-Host "Git dotfiles installation complete!" -ForegroundColor Green
Write-Host "Your git configuration is now at: $GitConfigPath" -ForegroundColor Cyan
