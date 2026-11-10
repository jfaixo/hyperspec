#!/usr/bin/env sh
# POSIX shell deterministic setup script for Hyperspec
set -e

WORKSPACE_ROOT="$(pwd)"
HYPERSPEC_DIR="${WORKSPACE_ROOT}/.hyperspec"
CONFIG_PATH="${HYPERSPEC_DIR}/hyperspec.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_ASSETS_DIR="${SCRIPT_DIR}/../assets/.hyperspec"

echo "[setup-hyperspec] Initializing Hyperspec v0.3.0..."

# 1. Ensure destination directory exists
mkdir -p "${HYPERSPEC_DIR}"

# 2. Mirror assets/.hyperspec (hyperspec.json, specs-organization.md, templates/) to destination
if [ ! -d "${SOURCE_ASSETS_DIR}" ]; then
    echo '{"status":"FAILED","error":"Source assets not found at '${SOURCE_ASSETS_DIR}'"}'
    exit 1
fi

cp -R "${SOURCE_ASSETS_DIR}"/* "${HYPERSPEC_DIR}/"
echo "[setup-hyperspec] Installed configuration, templates, and specs-organization.md to ${HYPERSPEC_DIR}"

echo '{"status":"SUCCESS","version":"0.3.0"}'

