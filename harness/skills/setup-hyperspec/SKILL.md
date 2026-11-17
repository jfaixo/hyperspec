---
name: setup-hyperspec
description: Initialize or bootstrap Hyperspec in a repository, setting up the root /.hyperspec/ directory from a selected standard.
disable-model-invocation: true
---

# `setup-hyperspec` Skill

## Execution Role

Initialize or update the workspace configuration directory `/.hyperspec/` from a standard packaged under `assets/standards/<standard>/`.

## Operational Constraints

- **Target Directory**: Target strictly `/.hyperspec/` at the workspace root.
- **Deterministic Offloading**: Execute `scripts/setup.ps1` on Windows or `scripts/setup.sh` on POSIX; invoke from the skill root or adjust paths accordingly.
- **Scope Limitation**: Leave source code and sample specs untouched; spec authoring belongs to `edit-specs`.

## Procedure

### 1. Standard Selection

Inspect `assets/standards/`:

- If only `default` exists, proceed directly with `default`.
- If multiple standards exist, prompt the user to pick one (defaulting to `default`) and pass it to the setup script.

### 2. Script Execution

Run the OS-appropriate script (passing the chosen standard when multiple exist):

- **Windows**:
  ```powershell
  powershell -ExecutionPolicy Bypass -File scripts/setup.ps1 [standard]
  ```
- **POSIX (Linux/macOS)**:
  ```bash
  sh scripts/setup.sh [standard]
  ```

### 3. Verification Gate

- Confirm the script outputs status `SUCCESS`.
- Confirm `/.hyperspec/hyperspec.json` exists and contains `"version": "0.3.0"`.
- Confirm `/.hyperspec/specs-organization.md`, `/.hyperspec/specignore`, and `/.hyperspec/templates/` exist.

## Output Schema

<output_contract>
Upon completing initialization, emit:

### Hyperspec Setup Summary

- **Hyperspec Version**: `0.3.0`
- **Standard**: `[selected standard]`
- **Status**: `[SUCCESS | FAILED]`
  </output_contract>
