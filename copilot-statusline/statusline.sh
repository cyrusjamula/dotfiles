#!/bin/bash
set -euo pipefail

# Copilot CLI statusline renderer using Oh My Posh
# Reads Copilot session state from stdin (JSON), sets env vars, renders via OMP.

format_tokens() {
    local value="$1"
    if [[ -z "$value" || "$value" == "null" ]]; then
        echo "?"
        return
    fi
    awk "BEGIN { v=$value; if (v>=1000000) printf \"%.1fm\", v/1000000; else if (v>=1000) printf \"%.1fk\", v/1000; else printf \"%d\", v }"
}

format_duration() {
    local ms="$1"
    if [[ -z "$ms" || "$ms" == "null" || "$ms" == "0" ]]; then
        echo "00:00:00"
        return
    fi
    local total_seconds=$(( ${ms%.*} / 1000 ))
    local hours=$(( total_seconds / 3600 ))
    local minutes=$(( (total_seconds % 3600) / 60 ))
    local seconds=$(( total_seconds % 60 ))
    printf "%02d:%02d:%02d" "$hours" "$minutes" "$seconds"
}

make_gauge() {
    local percent="$1"
    if [[ -z "$percent" || "$percent" == "null" ]]; then
        echo ".........."
        return
    fi
    local bounded=${percent%.*}
    (( bounded > 100 )) && bounded=100
    (( bounded < 0 )) && bounded=0
    local filled=$(( bounded / 10 ))
    local empty=$(( 10 - filled ))
    printf '%0.s#' $(seq 1 $filled 2>/dev/null) || true
    printf '%0.s.' $(seq 1 $empty 2>/dev/null) || true
    echo
}

# Read JSON payload from stdin
payload="$(cat)"

if ! command -v jq >/dev/null 2>&1; then
    echo -n "Copilot status (jq not installed)"
    exit 0
fi

if [[ -z "$payload" ]] || ! echo "$payload" | jq . >/dev/null 2>&1; then
    echo -n "Copilot status unavailable"
    exit 0
fi

# Parse fields
current_tokens=$(echo "$payload" | jq -r '.context_window.current_context_tokens // empty')
context_limit=$(echo "$payload" | jq -r '.context_window.displayed_context_limit // empty')
context_percent=$(echo "$payload" | jq -r '.context_window.current_context_used_percentage // .context_window.used_percentage // empty')
duration_ms=$(echo "$payload" | jq -r '.cost.total_duration_ms // empty')
lines_added=$(echo "$payload" | jq -r '.cost.total_lines_added // "0"')
lines_removed=$(echo "$payload" | jq -r '.cost.total_lines_removed // "0"')
cwd=$(echo "$payload" | jq -r '.cwd // empty')

# Set environment variables for Oh My Posh template
export COPILOT_STATUS_CONTEXT="$(format_tokens "$current_tokens")/$(format_tokens "$context_limit")"
export COPILOT_STATUS_GAUGE="$(make_gauge "$context_percent")"
export COPILOT_STATUS_DURATION="$(format_duration "$duration_ms")"

if [[ "$lines_added" != "0" || "$lines_removed" != "0" ]]; then
    export COPILOT_STATUS_CHANGES="+${lines_added}/-${lines_removed}"
else
    export COPILOT_STATUS_CHANGES=""
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME="$SCRIPT_DIR/statusline.omp.json"
PWD_ARG="${cwd:-$(pwd)}"

if command -v oh-my-posh >/dev/null 2>&1 && [[ -f "$THEME" ]]; then
    output=$(oh-my-posh print primary --config "$THEME" --pwd "$PWD_ARG" --force --escape=false 2>/dev/null || true)
    if [[ -n "$output" ]]; then
        printf '%s' "$output"
        exit 0
    fi
fi

# Fallback: plain text
changes=""
[[ -n "$COPILOT_STATUS_CHANGES" ]] && changes=" $COPILOT_STATUS_CHANGES"
printf 'ctx %s %s time %s%s' "$COPILOT_STATUS_CONTEXT" "$COPILOT_STATUS_GAUGE" "$COPILOT_STATUS_DURATION" "$changes"
