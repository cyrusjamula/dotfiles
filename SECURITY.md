# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this repository, please report it responsibly:

1. **Do not** open a public issue for security vulnerabilities
2. Email [cyrus@jamula.net](mailto:cyrus@jamula.net) with details
3. Include steps to reproduce and potential impact

You can expect an acknowledgment within 48 hours and a resolution within 7 days for confirmed issues.

## Scope

This is a personal dotfiles repository. Security concerns primarily involve:

- Accidental credential/secret exposure in configuration files
- Unsafe script execution patterns (e.g., piping curl to shell)
- Symlink-based attacks in install scripts

## Best Practices

The install scripts in this repo follow these security practices:

- Downloads are saved to temp files before execution (not piped directly)
- Scripts use `set -euo pipefail` for strict error handling
- No secrets or tokens are stored in configuration files
- `.gitignore` excludes sensitive local files
