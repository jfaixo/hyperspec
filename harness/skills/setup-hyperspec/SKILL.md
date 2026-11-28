---
name: setup-hyperspec
description: Initialize or bootstrap Hyperspec in a repository, setting up the root /.hyperspec/ directory from a selected standard.
disable-model-invocation: true
---

# `setup-hyperspec` Skill

## Role & Purpose

Initialize or update `/.hyperspec/` from a standard packaged under `assets/standards/<standard>/`, configure the issue tracker, and verify environment readiness.

## Operational Constraints

- **Target Directory**: Target strictly `/.hyperspec/` at the workspace root.
- **Deterministic Offloading**: Run scripts from the workspace root, adjusting paths to the skill directory (`scripts/setup.*` and `scripts/preflight.*`).
- **Scope Limitation**: Leave source code and sample specs untouched; spec authoring belongs to `/specs`.

## Procedure

### 1. Standard Selection

Inspect `assets/standards/`:

- If only `default` exists, proceed directly with `default`.
- If multiple standards exist, prompt the user to pick one (defaulting to `default`) and pass it to the setup script.

### 2. Issue Tracker Selection & Setup Script Execution

1. Ask the user which issue tracker to use: `github`, `gitlab`, `local`, or `custom`.
2. Run the OS-appropriate setup script (passing `--standard`/`-Standard` when multiple exist and `--issue-tracker`/`-IssueTracker` with the selected tracker):

- **Windows**:
  ```powershell
  powershell -ExecutionPolicy Bypass -File scripts/setup.ps1 [-Standard <standard>] -IssueTracker <tracker>
  ```
- **POSIX (Linux/macOS)**:
  ```bash
  sh scripts/setup.sh [--standard <standard>] --issue-tracker <tracker>
  ```

Confirm the script outputs status `SUCCESS`.

### 3. Issue Tracker Configuration

1. Store the selection in `/.hyperspec/hyperspec.json` under `"issue-tracker"`, preserving existing keys.
2. When `custom` is selected:
   - Ask the user to describe how to list, view, create, and update issues.
   - Save the procedure for each action in `/.hyperspec/issue-tracker-manual.md` under dedicated sections (`List Issues`, `View an Issue`, `Create an Issue`, `Update an Issue`).

### 4. Preflight Checks

Run the OS-appropriate preflight script:

- **Windows**:
  ```powershell
  powershell -ExecutionPolicy Bypass -File scripts/preflight.ps1
  ```
- **POSIX (Linux/macOS)**:
  ```bash
  sh scripts/preflight.sh
  ```

Resolve any reported failure and re-run the preflight script:

- `git_installed`: Instruct the user to install `git` before retrying.
- `git_repository`: Ask whether to initialize a new repository (`git init`) or link to an existing remote; when linking to a remote, prompt for the remote URL, run `git init` and `git remote add origin <url>`, then re-run preflight.
- `github_cli_installed` / `github_cli_ready`: Instruct the user to install `gh` and run `gh auth login`, then re-run preflight.
- `gitlab_cli_installed` / `gitlab_cli_ready`: Instruct the user to install `glab` and run `glab auth login`, then re-run preflight.

### 5. Verification Gate

- Confirm both setup and preflight scripts output status `SUCCESS`.
- Confirm `/.hyperspec/hyperspec.json` exists and contains `"version": "0.3.1"` and `"issue-tracker"`.
- Confirm `/.hyperspec/issue-tracker-manual.md` exists.
- Confirm `/.hyperspec/specs-organization.md`, `/.hyperspec/implementation-procedure.md`, `/.hyperspec/alignment-procedure.md`, `/.hyperspec/specignore`, and `/.hyperspec/templates/` exist.

## Output Schema

<output_contract>
Upon completing initialization, emit:

### Hyperspec Setup Summary

- **Hyperspec Version**: `0.3.1`
- **Standard**: `[selected standard]`
- **Issue Tracker**: `[github | gitlab | local | custom]`
- **Status**: `[SUCCESS | FAILED]`
  </output_contract>
