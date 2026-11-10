---
name: align-to-specs
description: Orchestrate end-to-end alignment of the codebase to the specifications.
disable-model-invocation: true
---

## Role & Purpose

Orchestrate the realignment of the codebase to specifications.

## Procedure

### 1. Progress Tracking

Initialize and continuously update an alignment status graph artifact (`alignment-status`) tracking each phase, identified tests, and items.

Update the graph after each subagent execution and validation step to reflect current status, in-flight agents, newly unblocked runnable horizon, and passing/failing tests.

### 2. Compute Spec Deltas

Execute the dedicated script:

```bash
node scripts/spec_delta.js
```

### 3. Scope Target Specs (`align-context-scoper`)

Invoke an align-context-scoper subagent to execute `/align-context-scoper`, passing it the spec delta:

- For each spec not in `ALIGNED` state, compute the delta between its last `ALIGNED` state and its current state (via the dedicated skill script).
- Return a scoped report of all specifications, deltas, and item dependencies requiring alignment.
- Update the `alignment-status` artifact with scoped specs, affected tests, and target items.

### 4. Execute alignment procedure

Strictly follow the alignment procedure defined in `/.hyperspec/alignment-procedure.md`.

### 5. Mark Specs Aligned

Update the status metadata of all specifications to `ALIGNED`, and mark the alignment complete in the `alignment-status` artifact.
