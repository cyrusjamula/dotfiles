# WinGet Bootstrap

Installs [WinGet](https://learn.microsoft.com/windows/package-manager/winget/) on Windows if it is not already available.

## Installation

**Windows PowerShell:**

```powershell
cd winget; .\install.ps1
```

**Linux/macOS/WSL:**

```bash
cd winget && ./install.sh
```

The Bash installer is a no-op and prints guidance to run the PowerShell installer on Windows.

## What the PowerShell installer does

1. Checks that the shell provides `Add-AppxPackage`.
2. Exits successfully if `winget` is already available and prints its version.
3. Downloads the latest App Installer bundle from `https://aka.ms/getwinget` to `%TEMP%\Microsoft.DesktopAppInstaller.msixbundle`.
4. Installs it with `Add-AppxPackage`.
5. Verifies `winget` availability and prints the version.

## Requirements

- Windows with AppX package support
- Windows PowerShell 5.1 or newer
- Network access to `https://aka.ms/getwinget`

## Notes

- WinGet is only supported on Windows.
- You may need to open a new terminal after installation.
- If App Installer completes but `winget` remains unavailable, install **App Installer** from Microsoft Store.
- The installer does not remove the downloaded bundle from `%TEMP%`.
