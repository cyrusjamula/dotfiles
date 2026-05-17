#Requires -Version 5.1
$ErrorActionPreference = "Stop"

# Copilot CLI statusline installation script for PowerShell

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CopilotDir = Join-Path $env:USERPROFILE ".copilot"

Write-Host "Installing Copilot CLI statusline..." -ForegroundColor Green

# Ensure .copilot directory exists
if (-not (Test-Path $CopilotDir)) {
    New-Item -ItemType Directory -Path $CopilotDir -Force | Out-Null
}

# Copy statusline files
Write-Host "Installing statusline.ps1" -ForegroundColor Blue
Copy-Item (Join-Path $DotfilesDir "statusline.ps1") (Join-Path $CopilotDir "statusline.ps1") -Force

Write-Host "Installing statusline.cmd" -ForegroundColor Blue
Copy-Item (Join-Path $DotfilesDir "statusline.cmd") (Join-Path $CopilotDir "statusline.cmd") -Force

Write-Host "Installing statusline.omp.json" -ForegroundColor Blue
Copy-Item (Join-Path $DotfilesDir "statusline.omp.json") (Join-Path $CopilotDir "statusline.omp.json") -Force

# Update settings.json
$SettingsFile = Join-Path $CopilotDir "settings.json"
$StatuslineCmd = (Join-Path $CopilotDir "statusline.cmd") -replace '\\', '\\'

if (Test-Path $SettingsFile) {
    $BackupPath = "$SettingsFile.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item $SettingsFile $BackupPath -Force
    Write-Host "Backed up existing settings.json to $BackupPath" -ForegroundColor Yellow

    $settings = Get-Content $SettingsFile -Raw | ConvertFrom-Json

    # Add statusline config
    $statusLine = @{ type = "command"; command = $StatuslineCmd; padding = 1 }
    $settings | Add-Member -NotePropertyName "statusLine" -NotePropertyValue $statusLine -Force
    $settings | Add-Member -NotePropertyName "experimental" -NotePropertyValue $true -Force

    # Merge STATUS_LINE into feature_flags.enabled
    if (-not $settings.feature_flags) {
        $settings | Add-Member -NotePropertyName "feature_flags" -NotePropertyValue @{ enabled = @("STATUS_LINE") } -Force
    } elseif (-not $settings.feature_flags.enabled) {
        $settings.feature_flags | Add-Member -NotePropertyName "enabled" -NotePropertyValue @("STATUS_LINE") -Force
    } elseif ($settings.feature_flags.enabled -notcontains "STATUS_LINE") {
        $settings.feature_flags.enabled += "STATUS_LINE"
    }

    $settings | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile -Encoding UTF8
    Write-Host "Updated settings.json with statusline configuration" -ForegroundColor Green
} else {
    @{
        statusLine = @{ type = "command"; command = $StatuslineCmd; padding = 1 }
        feature_flags = @{ enabled = @("STATUS_LINE") }
        experimental = $true
    } | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile -Encoding UTF8
    Write-Host "Created settings.json with statusline configuration" -ForegroundColor Green
}

Write-Host ""
Write-Host "Copilot CLI statusline installation complete!" -ForegroundColor Green
Write-Host "Run /restart in Copilot CLI to activate the statusline." -ForegroundColor Yellow
