# Copilot CLI Statusline

Oh My Posh-powered statusline for GitHub Copilot CLI, based on [Scott Hanselman's gist](https://gist.github.com/shanselman/9623ac74888a07ba82f63f5310fda11b).

## What it shows

```
<git branch> <runtime> ctx <tokens used>/<limit> <gauge> <duration> <line changes>
```

Example:

```
 main  ctx 123.5k/200.0k  ######....  00:12:34  +42/-8
```

## Installation

**Linux/macOS/WSL:**

```bash
cd copilot-statusline && ./install.sh
```

**Windows PowerShell:**

```powershell
cd copilot-statusline; .\install.ps1
```

After installation, run `/restart` in Copilot CLI.

## Files

| File | Purpose |
|------|---------|
| `statusline.sh` | Bash renderer (reads JSON stdin, renders via Oh My Posh) |
| `statusline.ps1` | PowerShell renderer |
| `statusline.cmd` | Windows command wrapper for PowerShell |
| `statusline.omp.json` | Oh My Posh theme for the statusline (uses repo theme palette) |
| `install.sh` | Linux/macOS installer |
| `install.ps1` | Windows installer |

## Requirements

- [Oh My Posh](https://ohmyposh.dev/) on `PATH`
- [jq](https://jqlang.github.io/jq/) (Linux/macOS install script uses it to merge settings)
- A Nerd Font for powerline glyphs
- GitHub Copilot CLI with experimental statusline support

## How it works

1. Copilot sends session state as JSON on stdin
2. The script parses tokens, duration, and line changes
3. Values are set as environment variables (`COPILOT_STATUS_*`)
4. Oh My Posh renders the statusline theme using those variables
5. Output is returned to Copilot on stdout
