# Security Policy

## Supported Version

This repository is maintained as a rolling configuration. Security fixes are applied to the default branch; older commits and downstream copies are not supported. Template users should review [SYNCING.md](SYNCING.md) to keep their copies current.

## Reporting a Vulnerability

If you discover a security vulnerability in this repository, please report it responsibly:

1. **Do not** open a public issue for security vulnerabilities
2. Email [cyrus@jamula.net](mailto:cyrus@jamula.net) with details
3. Include the affected file and revision, steps to reproduce, potential impact, and any suggested mitigation
4. Do not include live credentials, tokens, or other secrets in the report

You can expect an acknowledgment within 48 hours and a resolution within 7 days for confirmed issues.

## Scope

This is a personal dotfiles repository. Security concerns primarily involve:

- Accidental credential/secret exposure in configuration files
- Unsafe script execution patterns (e.g., piping curl to shell)
- Symlink-based attacks in install scripts
- Untrusted changes to downloaded installers, packages, or GitHub Actions
- Commands that can overwrite local configuration or delete branches

## Best Practices

The install scripts in this repo follow these security practices:

- Downloads are saved to temp files before execution (not piped directly)
- Scripts use `set -euo pipefail` for strict error handling
- No secrets or tokens are stored in configuration files
- `.gitignore` excludes sensitive local files
- Existing configuration is backed up before installers replace or update it

## Safe Usage

- Review installer changes before running them, especially when syncing from upstream.
- Inspect `git/.gitconfig` and replace the included user identity before installing from a template.
- Treat `.gitconfig.backup*` and `.copilot/settings.json.backup.*` files as sensitive because they may contain local credentials or private configuration.
- Prefer Windows Developer Mode or an elevated shell when you want symbolic links. When an installer falls back to copying, repository updates are not applied automatically.
- Review branches with `git branch -vv` before using `clearOldBranches`; it force-deletes branches whose upstream is gone.
- Never commit local tokens, private keys, credential helpers containing secrets, or machine-specific authentication files.
