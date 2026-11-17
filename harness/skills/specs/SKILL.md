---
name: specs
description: Load when creating, modifying, expanding, or refactoring specifications under /specs/, including core architectural specs and skill specs under specs/skills/. Use whenever adding new requirements or updating the specs, even if the user says "add a spec", "update the requirements", or "change the spec". Do not load for direct source code edits or running derivations.
disable-model-invocation: true
---

## Role & Purpose

Coordinate the authoring, expansion, and mutation of declarative specifications within the specs (`/specs/`). You delegate exploratory research and file editing to specialized subagents to keep context clean and ensure high-precision execution.

## Operational Constraints

- **Downstream Impact Deferral**: NEVER edit source code, tests, or documentation within this skill. All changes are restricted to the specs (`/specs/`).
- **Subagent Delegation**: Do NOT perform file viewing, file searching, or file writing directly in the primary session. Delegate scoping to `spec-context-scoper` and file modifications to `spec-editor`.

## Procedure

### 1. Context Scoping (Delegation to `spec-context-scoper`)

Invoke a scoper subagent with the user intent:

- The subagent must invoke the `/spec-context-scoper` skill and take as input the user intent.
- It returns:
  - **Context Specs**: Existing specifications providing necessary background and invariants.
  - **Target Specs**: Existing specifications to modify or new specification paths to create.

### 2. Specification Editing (Delegation to `spec-editor`)

Invoke a spec editor subagent subagent:

- Invoke the `/spec-editor` skill and take as input the user intent along with the **complete output report** produced by `spec-context-scoper`.
- It returns an execution summary report detailing changes made, structural validation status, and unsolved open points.

## Output Schema

<output_contract>
Upon receiving the execution report from `spec-editor`, emit the final summary:

### Specification Update Summary

- **Target Specs**: `[List of modified/created files under specs/]`
- **Context Specs Consulted**: `[List of context specs explored]`
- **Key Changes Applied**:
  - `[Summary item 1]`
  - `[Summary item 2]`
- **Status**: `[SUCCESS | FAILED]`

### Assumptions made

- `[Functional or technical assumption that has been done while editing specs]`

### Open Points

- `[List of unsolved open points, ambiguities, or architectural questions reported by spec-editor, or "None"]`
  </output_contract>
