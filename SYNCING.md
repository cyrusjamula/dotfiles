# Syncing with Upstream

If you created your repo from [`cyrusjamula/dotfiles`](https://github.com/cyrusjamula/dotfiles) using **Use this template**, GitHub copies the files but does **not** keep them linked to upstream. This guide shows how to pull updates from upstream into your downstream copy — either manually, or automatically via a GitHub Action.

Before syncing, commit or back up local changes and identify files that contain personal settings. Never accept changes to identity, credentials, or machine-specific configuration without reviewing them.

## Option 1: Automated Sync (Recommended)

Drop a workflow into your downstream repo that opens a PR whenever upstream changes. The repo ships an example you can copy:

```bash
# In your downstream repo (created from this template):
mkdir -p .github/workflows
curl -fsSL https://raw.githubusercontent.com/cyrusjamula/dotfiles/main/docs/examples/template-sync.yml \
  -o .github/workflows/template-sync.yml
git add .github/workflows/template-sync.yml
git commit -m "ci: add upstream template sync workflow"
git push
```

The workflow uses [`AndreasAugustin/actions-template-sync`](https://github.com/AndreasAugustin/actions-template-sync). By default it:

- Runs **weekly** (Mondays 09:00 UTC) and **on demand** via the Actions tab
- Opens a PR titled `chore(sync): pull latest from upstream template` with all upstream changes
- Skips files listed in `.templatesyncignore` so your personal customizations are preserved

The workflow requires GitHub Actions to be enabled and grants its job `contents: write` and `pull-requests: write` permissions so it can create a branch and pull request. Review and pin third-party action versions according to your repository's security policy before enabling it.

After installing, create a `.templatesyncignore` at your repo root to protect your personal files. A reasonable starting point:

```gitignore
# Personal config — never overwrite
git/.gitconfig
.squad/config.json
.vscode/settings.json
# Local Copilot CLI settings
.copilot/mcp-config.json
# Generated/transient
.squad/casting/
.squad/identity/
.squad/decisions.md
```

See [the example workflow](docs/examples/template-sync.yml) for full options (schedule, target branch, PR labels, etc.).

Run the workflow manually once after installation to verify its permissions, ignore rules, and pull-request behavior.

## Option 2: Manual Sync (Git Remote)

If you'd rather sync by hand:

Requirements:

- Git
- GitHub CLI (`gh`) for the final pull-request command, or the GitHub web interface instead

```bash
# One-time setup — add the template as a remote named "upstream"
git remote add upstream https://github.com/cyrusjamula/dotfiles.git

# Each time you want to pull updates:
git fetch upstream
git checkout -b sync/upstream-$(date +%Y%m%d) main
git merge upstream/main --allow-unrelated-histories   # first sync only
# or for subsequent syncs (after the first merge):
# git merge upstream/main

# Resolve any conflicts (typically in files you've customized)
git push -u origin HEAD
gh pr create --base main --fill
```

The `--allow-unrelated-histories` flag is only required the **first** time, because template-derived repos don't share git history with the source.

For later syncs, create a new branch from an up-to-date local `main` before merging `upstream/main`.

### Targeting a specific release

If you want to pin to a specific upstream release rather than tracking `main`:

```bash
git fetch upstream --tags
git merge v1.0.0   # or whatever release you want
```

See [Releases](https://github.com/cyrusjamula/dotfiles/releases) for the list of tagged versions.

## What Changes to Expect

Upstream changes typically fall into three buckets:

| Bucket | Examples | Action |
|---|---|---|
| **Shared infra** | `install.sh`, `install.ps1`, module installers, workflows | Usually safe to accept as-is |
| **Defaults** | `git/.gitconfig`, `ohmyposh/theme.omp.json`, shell functions | Review for conflicts with your personal tweaks |
| **Personal config** | `.squad/config.json`, `.vscode/settings.json`, anything you've edited | Add to `.templatesyncignore` or resolve manually |

## Resolving Conflicts

When the sync PR or merge has conflicts, the typical pattern is:

1. **Files you haven't touched** — accept upstream (`git checkout --theirs <file>`)
2. **Files you've personalized** — accept your version (`git checkout --ours <file>`), then add to `.templatesyncignore` so future syncs skip them
3. **Files where both sides have meaningful changes** — merge manually

After resolving conflicts:

1. Review the complete diff for unexpected identity, credential, workflow-permission, and installer changes.
2. Run the appropriate installers only after reviewing their changes.
3. Verify the modules you use on each supported platform.
4. Merge the sync pull request only after checks pass.

## Getting Help

Open an issue at [cyrusjamula/dotfiles/issues](https://github.com/cyrusjamula/dotfiles/issues) if you hit a sync problem you think others would also hit.
