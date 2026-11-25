---
hyperspec-version: 0.3.0
tags: opinionated
---

# Alignment Procedure

### 0. Validate/Initialize Runtime & Toolchain

Before proceeding with scoping or tests:

- Inspect cross-cutting technical specifications (`specs/01-cross-cutting/technical/*.md`).
- Verify that the required application frameworks (e.g., backend frameworks, frontend frameworks, runtime tools...) and base directory structure are initialized.
- If the project environment lacks the specified framework dependencies or directory structure, bootstrap the repository according to the technical architecture specification.

### 1. Activable Acceptance Criteria (AAC) implementation

- For each AAC that has been created/updated/removed, update its implementation accordingly, and update traceability.

### 2. Plan Specs Alignment & Dependency Graph

- Build the dependency DAG of all items requiring modifications based on scoped specs and dependencies.
- Identify the initial **runnable horizon**: items whose dependencies are already satisfied.
- Populate the `alignment-status` artifact with all items, their dependencies, and the initial runnable horizon.

### 3. Implement items Continuously via Dynamic Horizon

Continuously maintain and execute across the runnable horizon:

- Concurrently invoke a dedicated `implementer` subagent for each item currently in the runnable horizon executing `/implement`.
- As each item completes:
  - Mark it complete in the `alignment-status` artifact.
  - Re-evaluate the dependency DAG to unlock downstream items whose dependencies are now fulfilled.
  - Add newly unlocked items to the active runnable horizon and immediately spawn their implementers.
- Repeat until all items are completed.

### 4. Verify AAC

- Run all the acceptance criteria tests.
- If any test fails, diagnose the failure, spawn targeted `implementer` subagents to resolve it, then re-run tests until all pass.
- Mark tests as passed in the `alignment-status` artifact.
