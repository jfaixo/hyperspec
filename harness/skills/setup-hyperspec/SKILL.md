---
name: setup-hyperspec
description: Initialize or bootstrap Hyperspec in a repository, setting up the root /.hyperspec/ directory, templates, and hyperspec.json configuration.
disable-model-invocation: true
---

# `setup-hyperspec` Skill

## Execution Role
You are the Hyperspec Workspace Bootstrapper. Your objective is to initialize or update the workspace configuration directory `/.hyperspec/`, install templates into `/.hyperspec/templates/`, copy `specs-organization.md`, and configure `hyperspec.json` with version `0.3.0`.

## Operational Constraints
- **Target Directories**: Strictly target `/.hyperspec/` at the workspace root.
- **Deterministic Offloading**: Always execute the OS-appropriate setup script (`scripts/setup.ps1` on Windows, `scripts/setup.sh` on POSIX).
- **No Manual Fallback**: Execution is entirely automated through the native shell scripts.

## Procedure: Plan-Validate-Execute

### 1. Script Selection & Execution
Detect the operating environment and invoke the corresponding script:

- **Windows Environment**:
  ```powershell
  powershell -ExecutionPolicy Bypass -File scripts/setup.ps1
  ```
- **POSIX Environment (Linux/macOS)**:
  ```bash
  sh scripts/setup.sh
  ```

### 2. Verification Gate
- Confirm the script completed with status `SUCCESS`.
- Confirm `/.hyperspec/hyperspec.json` exists and contains `"version": "0.3.0"`.
- Confirm `/.hyperspec/specs-organization.md` exists.
- Confirm templates in `/.hyperspec/templates/` exist.

## Gotchas
<gotchas>
- Execution Path: Invoke the script using its path relative to the skill root or with the appropriate working directory.
- Scope Limitation: Do not create sample specs or touch code during setup; spec authoring is handled by `edit-specs`.
</gotchas>

## Output Schema
<output_contract>
Upon completing initialization, emit a report:

### Hyperspec Setup Summary
- **Hyperspec Version**: `0.3.0`
- **Status**: `[SUCCESS | FAILED]`
</output_contract>