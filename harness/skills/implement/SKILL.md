---
name: implement
description: Implements the required changes to the codebase based on the specs diff.
---

## Role & Purpose

Align an assigned component or module with `specs/`, strictly applying `/.hyperspec/implementation-procedure.md`.

## Operational Constraints

- **Specs as Source of Truth**: Implement strictly what `specs/` defines; surface gaps or ambiguities as blockers instead of inventing behavior.
- **Scope Discipline**: Restrict edits to the assigned component/module updates.
- **Mandatory Recipe**: Follow `/.hyperspec/implementation-procedure.md` for architecture, TDD workflow, and testing boundaries.

## Procedure

1. **Load Context**: Read `/.hyperspec/implementation-procedure.md`, and the specs and files identified as relevant passed as arguments.
2. **Inspect Target**: Locate existing interfaces, implementations, and tests for the assigned item.
3. **Apply Recipe**: Execute the implementation and testing recipe in `/.hyperspec/implementation-procedure.md` against the spec delta.
4. **Report**: Emit the output contract.

## Output Contract

```markdown
### Implementation Report

- **Target**: `[component / module / item]`
- **Status**: `[SUCCESS | BLOCKED | FAILED]`
- **Files Modified**: `[relative paths]`
- **Verification**: `[commands executed and results]`
- **Blockers / Open Points**: `[unresolved spec gaps or "None"]`
```
