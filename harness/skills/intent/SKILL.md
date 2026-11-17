---
name: intent
description: Create or edit a specs modification intent in your issue tracker.
---

# Agent Skill: Intent

Create or update a specification-modification intent issue in the repository's issue tracker.

## Role & Objective

Collaborate with the user to structure a high-level need using the repository's intent issue template, then create or update the issue via the repository's issue tracker.

## Procedure

### 1. Determine Action & Context

1. Load the matching issue tracker reference from `./assets/` and read `/.hyperspec/templates/intent-issue-template.md`.
2. Inspect the target issue when an issue number or URL is given; otherwise list or search open issues to prevent duplicates.
3. Gather high-level requirements: target personas, motivations, expected outcomes, scope boundaries, and likely impacted specifications. Ask clarifying questions when details are missing.
4. Keep requirements high-level; defer detailed acceptance criteria (AACs), test matrices, and low-level API contracts to `specs/` via `edit-specs`.

### 2. Draft & Review
1. Write a title respecting the constraints given in the template.
2. Fill every section of the template body, using relative paths for repository links.

### 3. Execute

Run the create or update command from the selected `./assets/` reference, passing the markdown body via a file or stdin to preserve formatting and backticks.

### 4. Verify & Report

1. View the created or updated issue with the tracker CLI to confirm the result.
2. Share the issue number and URL with the user.
3. State that the next step is either iterating on the issue content, or refining the design in `specs/` using the `edit-specs` skill.

### Annex: Available issue trackers

- **GitHub CLI (`gh`)**: [`./assets/github-cli.md`](./assets/github-cli.md)
- **GitLab CLI (`glab`)**: [`./assets/gitlab-cli.md`](./assets/gitlab-cli.md)