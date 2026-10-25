---
name: align-to-specs
description: Orchestrate end-to-end alignment of the codebase to the specifications using specialized subagents across scoping, testing, and micro-module implementation, tracked via a live alignment checklist artifact.
disable-model-invocation: true
---

# Align to Specs

Orchestrate the realignment of the codebase to specifications via specialized subagents, maintaining a live execution checklist artifact throughout the lifecycle.

## Progress Tracking
Initialize and continuously update an alignment checklist artifact (`alignment_checklist.md`) tracking each phase, identified tests, and µmods:
- [ ] 0. Validate/Initialize Runtime & Toolchain
- [ ] 1. Scope Target Specs (`align-context-scoper`)
- [ ] 2. Create/Update Failing E2E Tests (`e2e-tester`)
- [ ] 3. Create/Update Failing Integration Tests (`integration-tester`)
- [ ] 4. Plan µMod Alignment & Dependency Graph
- [ ] 5. Implement µMods dynamically as dependencies unblock (`µmod-implementer`)
- [ ] 6. Pass Integration Tests
- [ ] 7. Pass E2E Tests
- [ ] 8. Mark Specs Aligned

Update the artifact after each subagent execution and validation step to reflect current status, in-flight agents, newly unblocked runnable horizon, and passing/failing tests.

## Workflow

### 0. Validate/Initialize Runtime & Toolchain
Before proceeding with scoping or tests:
- Inspect cross-cutting technical specifications (`specs/01-cross-cutting/technical/*.md`).
- Verify that the required application frameworks (e.g., Astro.build, frontend frameworks, runtime tools) and base directory structure are initialized.
- If the project environment lacks the specified framework dependencies or directory structure, bootstrap the framework scaffold according to the technical architecture specification.

### 1. Scope Target Specs (`align-context-scoper`)
Invoke an align-context-scoper subagent to execute `/align-context-scoper`:
- For each spec not in `ALIGNED` state, compute the delta between its last `ALIGNED` state and its current state (via the dedicated skill script).
- Return a scoped report of all specifications, deltas, and component/µmod dependencies requiring alignment.
- Update `alignment_checklist.md` with scoped specs, affected tests, and target µmods.

### 2. End-to-End Tests (`e2e-tester`)
- Identify all E2E tests (tests requiring the full solution) to create or update from the scoped report.
- Invoke an `e2e-tester` subagent executing `/test-e2e` with the scoped report as input.
- Create or update the E2E tests in the codebase.
- Run the E2E tests and ensure they fail.
- Update `alignment_checklist.md` with authored E2E tests and red verification status.

### 3. Component-Level Integration Tests (`integration-tester`)
- Identify all affected components from the scoped report.
- Concurrently invoke one `integration-tester` subagent per affected component executing `/test-integration` with the scoped report for that component:
  - Create or update the component-level integration tests in the codebase, mapping each AAC to its explicitly covered µmods.
  - Run the component integration tests and ensure they fail.
- Update `alignment_checklist.md` with authored integration tests, covered µmods, and red verification status per component.

### 4. Plan µMod Alignment & Dependency Graph
- Build the dependency DAG of all µmods requiring modifications based on scoped specs and dependencies.
- Identify the initial **runnable horizon**: µmods whose dependencies are already satisfied.
- Populate `alignment_checklist.md` with all µmods, their dependencies, and the initial runnable horizon.

### 5. Implement µMods Continuously via Dynamic Horizon (`µmod-implementer`)
Continuously maintain and execute across the runnable horizon:
- Concurrently invoke a dedicated `µmod-implementer` subagent for each µmod currently in the runnable horizon executing `/implement-µmod`:
  - Apply TDD: create or update unit tests, verify they fail, then write minimal code to make them pass.
  - Hand back to the orchestrator once all unit tests for that µmod pass.
- As each µmod completes:
  - Mark it complete in `alignment_checklist.md`.
  - Re-evaluate the dependency DAG to unlock downstream µmods whose dependencies are now fulfilled.
  - Add newly unlocked µmods to the active runnable horizon and immediately spawn their implementers.
- Repeat until all target µmods are completed.

### 6. Verify Component-Level Integration Tests
- Run integration tests at the component level for all affected components.
- If any test fails, diagnose the failure, spawn targeted `µmod-implementer` subagents to resolve it, and re-run component integration tests until all pass.
- Mark integration tests as passed in `alignment_checklist.md`.

### 7. Verify E2E Tests
- Run all E2E tests across the codebase.
- If any test fails, diagnose the failure, spawn targeted `µmod-implementer` subagents to fix it, re-verify integration tests, and then re-verify E2E tests.
- Repeat until all integration and E2E tests pass.
- Mark E2E tests as passed in `alignment_checklist.md`.

### 8. Mark Specs Aligned
Update the status metadata of all verified specifications to `ALIGNED`, and mark the alignment complete in `alignment_checklist.md`.
