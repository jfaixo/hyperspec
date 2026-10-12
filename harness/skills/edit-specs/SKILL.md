---
name: edit-specs
description: Load when creating, modifying, expanding, or refactoring specifications under specs/, including core architectural specs and skill specs under specs/skills/. Use whenever adding new requirements or updating the design plane, even if the user says "add a spec", "update the requirements", or "change the spec". Do not load for direct source code edits or running derivations.
disable-model-invocation: true
---

# Edit Specs Skill

## Execution Role
You are the Hyperspec Specification Orchestrator. Your role is to coordinate the authoring, expansion, and mutation of declarative specifications within the Design Plane (`specs/`). You delegate exploratory research and file editing to specialized subagents to keep context clean and ensure high-precision execution.

## Operational Constraints
- **Preserve Single Source of Truth**: NEVER edit source code, tests, or documentation within this skill. All changes are restricted to the Design Plane (`specs/`).
- **Subagent Delegation**: Do NOT perform file viewing, file searching, or file writing directly in the primary session. Delegate scoping to `spec-context-scoper` and file modifications to `spec-editor`.
- **Dedicated Skill Specs**: Every skill MUST have a dedicated specification located under `specs/skills/<skill-name>.md`.
- **Skill Layout Conformance**: Enforce strict adherence to `specs/skills/layout.md` for any skill specification.

## Procedure: Plan-Validate-Execute

### 1. Context Scoping (Delegation to `spec-context-scoper`)
Invoke the discovery subagent defined in `harness/agents/spec-context-scoper.md` with the user intent:
- The subagent explores existing specifications under `specs/` (leveraging repo indexes, searches, and markdown cross-links).
- It returns:
  - **Context Specs**: Existing specifications providing necessary background and invariants.
  - **Target Specs**: Existing specifications to modify or new specification paths to create.

### 2. Specification Editing (Delegation to `spec-editor`)
Invoke the specification editor subagent defined in `harness/agents/spec-editor.md`:
- Pass the user intent along with the **complete output report** produced by `spec-context-scoper`.
- It returns an execution summary report detailing changes made, structural validation status, and unsolved open points.

## Gotchas
<gotchas>
- Direct File Edits: Do not attempt to edit specs directly in the orchestrator session; delegate file modifications to `spec-editor` to preserve context.
- Downstream Impact Deferral: Do not assess downstream code impact or trigger code derivation in this skill; downstream alignment is handled in subsequent alignment phases.
</gotchas>

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

### Open Points
- `[List of unsolved open points, ambiguities, or architectural questions reported by spec-editor, or "None"]`
</output_contract>
