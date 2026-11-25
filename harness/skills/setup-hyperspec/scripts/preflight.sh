#!/usr/bin/env sh
# POSIX shell preflight checks script for Hyperspec
set -e

WORKSPACE_ROOT="$(pwd)"
CONFIG_PATH="${WORKSPACE_ROOT}/.hyperspec/hyperspec.json"

fail() {
    echo "{\"status\":\"FAILED\",\"check\":\"$1\",\"error\":\"$2\"}"
    exit 1
}

check_cli() {
    prefix="$1"
    label="$2"
    cmd="$3"

    if ! command -v "$cmd" >/dev/null 2>&1; then
        fail "${prefix}_cli_installed" "${label} (${cmd}) is missing or not in PATH."
    fi

    if ! auth_output="$("$cmd" auth status 2>&1)"; then
        printf '%s\n' "$auth_output" >&2
        fail "${prefix}_cli_ready" "${label} (${cmd}) requires authentication. Run '${cmd} auth login'."
    fi
}

echo "[setup-hyperspec] Running preflight checks..."

if ! command -v git >/dev/null 2>&1; then
    fail "git_installed" "git is missing or not in PATH."
fi

if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null || true)" != "true" ]; then
    fail "git_repository" "Current directory is not a git repository."
fi

if [ ! -f "$CONFIG_PATH" ]; then
    fail "issue_tracker_config" "Missing ${CONFIG_PATH}."
fi

ISSUE_TRACKER="$((tr -d '\r\n' < "$CONFIG_PATH"; printf '\n') | sed -n 's/.*"issue-tracker"[ 	]*:[ 	]*"\([^"]*\)".*/\1/p')"

case "$ISSUE_TRACKER" in
    github)
        check_cli "github" "GitHub CLI" "gh"
        ;;
    gitlab)
        check_cli "gitlab" "GitLab CLI" "glab"
        ;;
    local|custom)
        ;;
    *)
        fail "issue_tracker_config" "Missing or invalid 'issue-tracker' in ${CONFIG_PATH}. Expected: github, gitlab, local, or custom."
        ;;
esac

echo "{\"status\":\"SUCCESS\",\"issue_tracker\":\"${ISSUE_TRACKER}\"}"

