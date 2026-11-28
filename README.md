<div align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/assets/logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="docs/assets/logo-light.svg">
    <img alt="Hyperspec" src="docs/assets/logo-light.svg" width="100" />
  </picture>
  <h1>HYPERSPEC</h1>
<div align="center">
  <p>Specs as an absolute, declarative design plane.</p>
  <p>If it's not in the spec, it doesn't exist.</p>
</div>
</div>
<p align="center">
  <a href="https://github.com/hyperspec-run/hyperspec/releases/latest"><img alt="GitHub Release" src="https://img.shields.io/github/v/release/hyperspec-run/hyperspec"></a>
  <a href="https://github.com/hyperspec-run/hyperspec/stargazers"><img src="https://img.shields.io/github/stars/hyperspec-run/hyperspec?style=social" alt="GitHub stars"/></a>
  <a href="https://github.com/hyperspec-run/hyperspec/blob/main/LICENSE.md"><img src="https://img.shields.io/github/license/hyperspec-run/hyperspec" alt="License"/></a>
</p>

## Summary

- [Hyperspec in 5 Minutes](#hyperspec-in-5-minutes)
- [Get Started](#get-started)
- [Other Skills](#other-skills)
- [Customization](#customization)
- [FAQ](#faq)

## Hyperspec in 5 Minutes

Hyperspec separates product evolution into **three planes**, keeping declarative specifications and codebase artifacts continuously synchronized.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/assets/hyperspec-in-5-minutes-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset="docs/assets/hyperspec-in-5-minutes-light.svg">
  <img alt="Hyperspec in 5 minutes across three planes: 1. Intent Plane (/intent) is decoupled and out of sync with the live product state, capturing desired changes (#42) in the issue tracker while you iterate until satisfied. 2. Design Plane (/specs) and Artifacts Plane (/align) are coupled and continuously synced: invoke /specs referencing #42 to update declarative specs/ (the absolute target state and single source of truth) and iterate until satisfied. 3. Invoke /align to reconcile source code, tests, and docs with specs/, iterating with /align to tune artifacts or returning to /specs to update specs." src="docs/assets/hyperspec-in-5-minutes-light.svg" width="100%" />
</picture>

- **Core loop (`specs/` ↔ artifacts)**: Specs and artifacts stay in sync and are versioned jointly in Git.
- **Design plane (`/specs`)**: Specs express the target state declaratively; steer them with `/specs`.
- **Artifacts plane (`/align`)**: Agents align artifacts to specs as closely as possible with `/align`.
- **Modification intents (`/intent`)**: Upstream and decoupled from the repository, allowing you to refine ideas with `/intent` before introducing them into specs.

## Get Started

### 1. Install the skills

Extract the harness archive at your repository root:

**Antigravity**

```bash
curl -sSL https://github.com/hyperspec-run/hyperspec/releases/latest/download/agents.tar.gz | tar -xz
```

**GitHub Copilot**

```bash
curl -sSL https://github.com/hyperspec-run/hyperspec/releases/latest/download/copilot.tar.gz | tar -xz
```

### 2. Run `/setup-hyperspec`

Invoke `/setup-hyperspec` in your agent session to initialize `/.hyperspec/`, configure your issue tracker, and run preflight checks.

## Other Skills

| Skill               | Purpose                                                                                           |
| :------------------ | :------------------------------------------------------------------------------------------------ |
| `/setup-hyperspec`  | Initialize `/.hyperspec/` from a standard, configure the issue tracker, and run preflight checks. |
| `/assess-alignment` | Run a read-only, two-way drift audit (`Spec ➔ Code` and `Code ➔ Spec`) and full test suites.      |
| `/index-content`    | Refresh existing `directory_map.md` navigation trees across the repository.                       |
| `/post-mortem`      | Analyze a completed conversation to extract friction points and apply durable skill/rule updates. |

## Customization

`/setup-hyperspec` installs your repository's Hyperspec configuration under `/.hyperspec/`. Edit these files directly to tailor Hyperspec to your stack and workflow:

| Area                         | File(s)                                                                                                 | Purpose                                                                                                        |
| :--------------------------- | :------------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------- |
| **Intent templates**         | `.hyperspec/templates/intent-issue-template.md`                                                         | Standardize issues created by `/intent`.                                                                       |
| **Issue tracker**            | `.hyperspec/issue-tracker-manual.md`, `.hyperspec/hyperspec.json`                                       | Configure how skills interact with your issue tracker.                                                         |
| **Specs layout & ignored**   | `.hyperspec/specs-organization.md`, `.hyperspec/specignore`                                             | Define `specs/` structure and exclude paths from spec deltas.                                                  |
| **Spec & audit templates**   | `.hyperspec/templates/spec-template.md`, `.hyperspec/templates/alignment-assessment-template.{md,json}` | Standardize specification authoring in `/specs` and drift reports in `/assess-alignment`.                      |
| **Alignment procedure**      | `.hyperspec/alignment-procedure.md`                                                                     | Define the global alignment process orchestrated by `/align` (typically delegating to `/implement` subagents). |
| **Implementation procedure** | `.hyperspec/implementation-procedure.md`                                                                | Define how each subagent executing `/implement` aligns assigned artifacts.                                     |
| **Agent rules**              | `.agents/rules/` (Antigravity) or `.github/AGENTS.md` (Copilot)                                         | Enforce workspace-wide agent constraints and conventions.                                                      |

## FAQ

**Why decouple `/intent` from `specs/`?**  
Intents capture _why_ a change is needed and tentative scope without polluting the declarative product state. `specs/` remains a clean, conflict-free model of what the product is.

**Can I skip `/intent` and start with `/specs`?**  
Yes. Use `/intent` for ideas that need async tracking or refinement; invoke `/specs` directly when ready to update the product design.

**Why forbid history or migration steps in `specs/`?**  
Git already stores history. Declarative specs let `/align` compute exact deltas against the last `ALIGNED` commit with zero ambiguity.

**How do I detect drift between specs and code?**  
Run `/assess-alignment` for a read-only two-way audit (`Spec ➔ Code` and `Code ➔ Spec`) and full test verification, then reconcile via `/specs` or `/align`.

**How do I optimize `/align` for my codebase?**  
Customize `.hyperspec/alignment-procedure.md` (test execution, framework checks, verification commands) and `.hyperspec/specignore` to match your project structure.
