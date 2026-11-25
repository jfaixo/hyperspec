#!/bin/bash

# Exit on any error
set -e

# Resolve absolute paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

HARNESS_DIR="$PROJECT_ROOT/harness"
DIST_DIR="$PROJECT_ROOT/dist"
COPILOT_DIR="$PROJECT_ROOT/dist/.github"
TAR_PATH="$PROJECT_ROOT/dist/copilot.tar.gz"

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

    # Remove the temporary .github/ folder if created
    if [ -d "$COPILOT_DIR" ]; then
      rm -rf "$COPILOT_DIR" >/dev/null 2>&1
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

if [ -d "$COPILOT_DIR" ]; then
  rm -rf "$COPILOT_DIR"
fi

# 2. Create the .github/ folder and copy harness contents (dereferencing symlinks)
mkdir -p "$COPILOT_DIR"

if [ -d "$HARNESS_DIR/skills" ]; then
  cp -aL "$HARNESS_DIR/skills" "$COPILOT_DIR/"
fi

if [ -d "$HARNESS_DIR/templates" ]; then
  cp -aL "$HARNESS_DIR/templates" "$COPILOT_DIR/"
fi

# 3. Concatenate rules into AGENTS.md
AGENTS_MD="$COPILOT_DIR/AGENTS.md"
echo "# Workspace rules" > "$AGENTS_MD"

if [ -d "$HARNESS_DIR/rules" ]; then
  for rule_file in "$HARNESS_DIR"/rules/*.md; do
    if [ -f "$rule_file" ]; then
      echo "" >> "$AGENTS_MD"
      awk '
        BEGIN { in_frontmatter = 0; dashes = 0 }
        /^---[[:space:]]*$/ {
          dashes++
          if (dashes == 1) { in_frontmatter = 1; next }
          if (dashes == 2) { in_frontmatter = 0; next }
        }
        {
          if (!in_frontmatter) {
            print
          }
        }
      ' "$rule_file" >> "$AGENTS_MD"
      echo "" >> "$AGENTS_MD"
    fi
  done
fi

# 4. Tar/gzip the .github folder (run from dist directory to keep relative paths correct)
cd "$DIST_DIR"
tar -czf "$TAR_PATH" ".github"

# 5. Output the full path of the tar.gz artifact to stdout
echo "$TAR_PATH"

# Mark script as successful
SUCCESS=true
exit 0
