# Oh My Posh installation script for PowerShell

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ThemeFile = Join-Path $DotfilesDir "theme.omp.json"

Write-Host "Installing Oh My Posh..." -ForegroundColor Green

# Install oh-my-posh if not already installed
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "Oh My Posh not found, installing..." -ForegroundColor Yellow
    winget install JanDeDobbeleer.OhMyPosh -s winget
} else {
    Write-Host "Oh My Posh is already installed" -ForegroundColor Cyan
}

# Add Oh My Posh initialization to PowerShell profile
$InitLine = "oh-my-posh init pwsh --config '$ThemeFile' | Invoke-Expression"

if (-not (Test-Path $PROFILE)) {
    Write-Host "Creating PowerShell profile at: $PROFILE" -ForegroundColor Blue
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$ProfileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if ($ProfileContent -and $ProfileContent.Contains("oh-my-posh init")) {
    Write-Host "Oh My Posh initialization already present in profile" -ForegroundColor Cyan
} else {
    Write-Host "Adding Oh My Posh initialization to PowerShell profile..." -ForegroundColor Blue
    Add-Content -Path $PROFILE -Value ""
    Add-Content -Path $PROFILE -Value "# Oh My Posh prompt"
    Add-Content -Path $PROFILE -Value $InitLine
    Write-Host "Oh My Posh initialization added to: $PROFILE" -ForegroundColor Green
}

Write-Host "Oh My Posh installation complete!" -ForegroundColor Green
Write-Host "Theme: $ThemeFile" -ForegroundColor Cyan
Write-Host "Please restart your shell or run: . `$PROFILE" -ForegroundColor Yellow
