#!/usr/bin/env pwsh
# scripts/notes/fetch.ps1
# ─────────────────────────────────────────────────────────────────────────────
# Fetch git notes from remote. Run on every Ralph-watch startup and before
# any agent reads or writes notes.
#
# Usage:
#   ./scripts/notes/fetch.ps1           # fetch only
#   ./scripts/notes/fetch.ps1 -Setup    # first-time: add refspec + fetch
#   ./scripts/notes/fetch.ps1 -Merge    # fetch + merge (use after push conflict)
# ─────────────────────────────────────────────────────────────────────────────

[CmdletBinding()]
param(
    [string]$Remote   = "origin",
    [string]$RepoPath = ".",
    [switch]$Setup,
    [switch]$Merge,
    [switch]$Quiet
)

function Log ([string]$msg, [string]$color = "White") {
    if (-not $Quiet) { Write-Host "[notes/fetch] $msg" -ForegroundColor $color }
}

$repo = Resolve-Path $RepoPath
$trackingPrefix = "refs/notes/remotes/$Remote/squad/"
$trackingRefspec = "+refs/notes/squad/*:${trackingPrefix}*"

# ── One-time setup: add fetch refspec ──────────────────────────────────────
if ($Setup) {
    $existing = @(git -C $repo config --get-all "remote.$Remote.fetch")
    foreach ($legacy in @("refs/notes/*:refs/notes/*", "+refs/notes/*:refs/notes/*")) {
        if ($existing -contains $legacy) {
            git -C $repo config --fixed-value --unset-all "remote.$Remote.fetch" $legacy
            if ($LASTEXITCODE -ne 0) {
                Write-Error "Failed to remove the unsafe local-notes fetch refspec."
                exit 1
            }
        }
    }
    if ($existing -contains $trackingRefspec) {
        Log "Notes refspec already configured." DarkGray
    } else {
        git -C $repo config --add "remote.$Remote.fetch" $trackingRefspec
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to configure the notes tracking refspec."
            exit 1
        }
        Log "Added notes refspec to remote.$Remote.fetch" Green
    }
}

# ── Fetch notes ─────────────────────────────────────────────────────────────
Log "Fetching notes from $Remote..."
$output = git -C $repo fetch $Remote $trackingRefspec 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to fetch notes from ${Remote}: $output"
    exit 1
} else {
    Log "Notes fetched." Green
}

# ── Merge notes if requested (after push conflict) ──────────────────────────
if ($Merge) {
    # Abort any stale merge-in-progress state
    $mergeLock = git -C $repo rev-parse --path-format=absolute --git-path NOTES_MERGE_PARTIAL
    if (Test-Path $mergeLock) {
        Log "Stale notes merge in progress — aborting before retry" DarkYellow
        git -C $repo notes merge --abort 2>&1 | Out-Null
    }

    $remoteRefs = git -C $repo for-each-ref $trackingPrefix --format="%(refname)"
    foreach ($remoteRef in $remoteRefs) {
        $ns = "squad/" + $remoteRef.Substring($trackingPrefix.Length)
        Log "Merging notes: $ns (cat_sort_uniq)"
        git -C $repo notes --ref=$ns merge -s cat_sort_uniq $remoteRef 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            git -C $repo notes --ref=$ns merge --abort 2>&1 | Out-Null
            Write-Error "Failed to merge remote notes into $ns; local notes were preserved."
            exit 1
        }
    }
    Log "Notes merge complete." Green
}

# ── Show available namespaces ────────────────────────────────────────────────
if (-not $Quiet) {
    $refs = git -C $repo for-each-ref "refs/notes/squad/" --format="%(refname)" 2>&1
    if ($refs) {
        Log "Available namespaces:"
        foreach ($r in $refs) {
            $count = (git -C $repo notes --ref=($r -replace "refs/notes/","") list 2>&1 |
                      Where-Object { $_ -ne "" } | Measure-Object -Line).Lines
            Log "  $r  ($count notes)" DarkGray
        }
    } else {
        Log "No squad notes yet." DarkGray
    }
}

exit 0
