---
trigger: glob
globs: *.md
tags: opinionated
---
## Enforce unique Acceptance Test identifiers

When specifying a new acceptance test, create new acceptance criteria with explicit unique IDs, in the format `aac-[domain/feature]-[index]` (e.g., `aac-domain-ingestion-1` or `aac-tooling-rust-workspace-1`)
