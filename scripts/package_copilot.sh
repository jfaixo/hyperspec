#!/bin/bash

# Exit on any error
set -e

# Resolve absolute paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

HARNESS_DIR="$PROJECT_ROOT/harness"
STANDARDS_DIR="$PROJECT_ROOT/standards"
ISSUE_TRACKERS_DIR="$PROJECT_ROOT/issue-trackers"
STAGING_DIR="$PROJECT_ROOT/.copilot_staging"
COPILOT_DIR="$STAGING_DIR/.github"
TAR_PATH="$PROJECT_ROOT/copilot.tar.gz"

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

    # Remove the temporary staging folder if created
    if [ -d "$STAGING_DIR" ]; then
      rm -rf "$STAGING_DIR" >/dev/null 2>&1
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

if [ ! -d "$ISSUE_TRACKERS_DIR" ]; then
  echo "Error: issue-trackers directory '$ISSUE_TRACKERS_DIR' does not exist." >&2
  exit 1
fi

if [ -z "$(ls -A "$ISSUE_TRACKERS_DIR")" ]; then
  echo "Error: issue-trackers directory '$ISSUE_TRACKERS_DIR' is empty." >&2
  exit 1
fi

if [ -d "$STAGING_DIR" ]; then
  echo "Error: staging directory '$STAGING_DIR' already exists. Please remove it first." >&2
  exit 1
fi

# 2. Create the staging directory and copy harness contents and standards
mkdir -p "$COPILOT_DIR"

if [ -d "$HARNESS_DIR/skills" ]; then
  cp -a "$HARNESS_DIR/skills" "$COPILOT_DIR/"
fi

if [ -d "$COPILOT_DIR/skills/setup-hyperspec" ]; then
  SETUP_STANDARDS_DIR="$COPILOT_DIR/skills/setup-hyperspec/assets/standards"
  mkdir -p "$SETUP_STANDARDS_DIR"
  for standard_dir in "$STANDARDS_DIR"/*; do
    if [ -d "$standard_dir" ]; then
      cp -a "$standard_dir" "$SETUP_STANDARDS_DIR/"
    fi
  done

  SETUP_ISSUE_TRACKERS_DIR="$COPILOT_DIR/skills/setup-hyperspec/assets/issue-trackers"
  mkdir -p "$SETUP_ISSUE_TRACKERS_DIR"
  cp -a "$ISSUE_TRACKERS_DIR"/. "$SETUP_ISSUE_TRACKERS_DIR"/
fi

if [ -d "$HARNESS_DIR/templates" ]; then
  cp -a "$HARNESS_DIR/templates" "$COPILOT_DIR/"
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

# 4. Tar/gzip the .github folder (run from staging directory to keep relative paths correct)
cd "$STAGING_DIR"
tar -czf "$TAR_PATH" .github

# 5. Clean the temporary folders, only keeping the tar.gz artifact
rm -rf "$STAGING_DIR"

# 6. Output the full path of the tar.gz artifact to stdout
echo "$TAR_PATH"

# Mark script as successful
SUCCESS=true
exit 0
