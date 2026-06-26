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

1. Checks if `winget` is already available.
2. Downloads the latest App Installer bundle from `https://aka.ms/getwinget`.
3. Installs it with `Add-AppxPackage`.
4. Verifies `winget` availability and prints the version.

## Notes

- WinGet is only supported on Windows.
- You may need to open a new terminal after installation.
