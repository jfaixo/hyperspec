#!/bin/bash

# Exit on any error
set -e

# Resolve absolute paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

HARNESS_DIR="$PROJECT_ROOT/harness"
STANDARDS_DIR="$PROJECT_ROOT/standards"
DIST_DIR="$PROJECT_ROOT/dist"
AGENTS_DIR="$PROJECT_ROOT/dist/.agents"
TAR_PATH="$PROJECT_ROOT/dist/agents.tar.gz"

SUCCESS=false

cleanup() {
  # Disable trap to avoid recursion
  trap - EXIT

  if [ "$SUCCESS" = "false" ]; then
    echo "Error occurred. Cleaning up and rolling back..." >&2

    # Remove partial tar.gz artifact if created
    if [ -f "$TAR_PATH" ]; then
      rm -f "$TAR_PATH" >/dev/null 2>&1
    fi

    # Remove the temporary .agents/ folder if created
    if [ -d "$AGENTS_DIR" ]; then
      rm -rf "$AGENTS_DIR" >/dev/null 2>&1
    fi

    exit 1
  fi
}

# Register cleanup on exit
trap cleanup EXIT

# 1. Verification of preconditions
if [ ! -d "$HARNESS_DIR" ]; then
  echo "Error: harness directory '$HARNESS_DIR' does not exist." >&2
  exit 1
fi

if [ -z "$(ls -A "$HARNESS_DIR")" ]; then
  echo "Error: harness directory '$HARNESS_DIR' is empty." >&2
  exit 1
fi

if [ ! -d "$STANDARDS_DIR" ]; then
  echo "Error: standards directory '$STANDARDS_DIR' does not exist." >&2
  exit 1
fi

HAS_STANDARD=false
for standard_dir in "$STANDARDS_DIR"/*; do
  if [ -d "$standard_dir" ]; then
    HAS_STANDARD=true
    break
  fi
done
if [ "$HAS_STANDARD" = "false" ]; then
  echo "Error: standards directory '$STANDARDS_DIR' has no standard subdirectories." >&2
  exit 1
fi

if [ -d "$AGENTS_DIR" ]; then
  rm -rf "$AGENTS_DIR"
fi

# 2. Create the .agents/ folder and copy harness contents and standards
mkdir -p "$AGENTS_DIR"
cp -a "$HARNESS_DIR"/. "$AGENTS_DIR"/

if [ -d "$AGENTS_DIR/skills/setup-hyperspec" ]; then
  SETUP_STANDARDS_DIR="$AGENTS_DIR/skills/setup-hyperspec/assets/standards"
  mkdir -p "$SETUP_STANDARDS_DIR"
  for standard_dir in "$STANDARDS_DIR"/*; do
    if [ -d "$standard_dir" ]; then
      cp -a "$standard_dir" "$SETUP_STANDARDS_DIR/"
    fi
  done
fi

# 3. Tar/gzip the .agents folder (run from project root to keep relative paths correct)
cd "$DIST_DIR"
tar -czf "$TAR_PATH" ".agents"

# 4. Output the full path of the tar.gz artifact to stdout
echo "$TAR_PATH"

# Mark script as successful
SUCCESS=true
exit 0
