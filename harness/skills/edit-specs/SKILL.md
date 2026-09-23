---
name: edit-specs
description: Entrypoint for writing, updating, and collaborating on one or many absolute declarative specifications.
---

## 🎯 Role & Objective

Your objective is to help the user design the product by authoring or modifying one or many specification files inside the `specs/` directory. You do not write or edit any codebase files; your sole output is the specification files.

## 🛠️ Execution Protocol

### Step 1: Gather Requirements & User Intent

1. Listen to the user's description of the feature, component, or change they want to introduce.
2. Ask clarifying questions regarding edge cases, UI layout, state, API contracts, and business rules.

### Step 2: Write or Edit Specifications

1. Identify and navigate to the relevant specification file(s) or create new ones inside the `specs/` directory (editing can touch one or many spec files). Leverage the `specs/index.md` file.
2. Refer to the template structure from [spec-template.md](../../templates/spec-template.md) for any new specification files. Either apply it, or if already specified, make sure the spec file aligns with this template structure.
3. Set the metadata `status` field of all newly created or modified specifications to `DRAFT`.
4. **Cross-Cutting Spec Changes**: When a cross-cutting spec (under `specs/01-cross-cutting/`) is edited:
   - Check all component specs (under `specs/02-components/`) to assess if the change affects them.
   - If a component spec is affected:
     - Change its status to `DRAFT` if a modification to the component spec itself is required.
     - Change its status to `APPROVED` if it is affected but no modification to the component spec document itself is required (e.g., to trigger realignment in the codebase).
5. Organize specification files according to the folder hierarchy defined in [specs-organization.md](references/specs-organization.md).
6. Ensure the specifications are **absolute and declarative**:
   - Describe only the target state (the "now" of the design).
   - Do not describe changes, migrations, history, or steps (e.g., avoid "Add a field" or "Rename button"; write "The interface includes X field").
7. Define tables for schemas, APIs, properties, and configurations.

### Step 3: Prompt for User Approval

1. Present the updated or newly created specification file(s) to the user.
2. Request explicit feedback and approval before ending your cycle. Do not proceed to any code changes.
3. Once the user explicitly approves the specification modifications, update the `status` metadata field of all approved specification files to `APPROVED`.
4. After the specification files are approved, trigger the index-content skill to update the indexes.

---

## 🚫 Critical Constraints & Rules

1. **No Code Modification**: Under no circumstances should you edit source files or config files outside of the specifications.
2. **Absolute Declarative Grammar**: Use present-tense, declarative statements describing the system behavior. No temporal transitions or step-by-step instructions.
3. **Template Adherence**: Always respect the headings and tabular layouts outlined in the template.
4. **Hyperlinking**: Whenever possible, link cited resources to their definition or place of specification leveraging Markdown links.
5. **Specification Organization**: Always structure specification files hierarchically inside the `specs/` folder as detailed in [specs-organization.md](references/specs-organization.md).
6. **No Code Snippets**: Specifications must not contain source code snippets (e.g., Rust, JavaScript, Python, etc.). Instead, leverage tables, text definitions, or Mermaid diagrams to specify workflows, data schemas, configurations, and behaviors.
7. **One-to-One E2E Test Mapping & Traceability**: Each activable acceptance criterion (AAC) must be presented in a clean Markdown table format (`| Criterion ID | Description | Target Test |`) and map to exactly one dedicated E2E test function, linked via a relative markdown link (e.g., `[test_name](../../path/to/test_file)`). One E2E test function must not cover multiple criteria. Acceptance criteria IDs must be lowercase and explicit with a domain/feature prefix (e.g., `aac-domain-ingestion-1`), and numbering for each AAC must start at 1 per spec prefix (for example: `aac-design-system-badge-label-1`, `aac-design-system-badge-label-2`, where `aac-design-system-badge-label` is the spec prefix). E2E test names must be prefixed with the lowercase ID of the corresponding acceptance criteria for easy backtracking. Corresponding test code functions must include a comment referring to the spec and line number for bidirectional traceability. Links in markdown must be written as `[link_text](relative/path/to/file)` without outer backticks.
8. **No Pure Indirection Specs**: Avoid creating or keeping specification files that serve purely as tables of contents or link lists without declaring any normative rules, schemas, invariants, or criteria. If a spec file only points to child specs, consider it redundant and prune/consolidate it into `specs/index.md`.
9. **No Data Stack Duplication in Component Specs**: Component specifications under `specs/02-components/` MUST NOT duplicate technology stack details, database engine versions, or driver implementation specifics. They must focus exclusively on component responsibilities, ports, contracts, and criteria, cross-linking to [technical-architecture.md](../../01-cross-cutting/technical/technical-architecture.md) for data stack infrastructure.
10. **Hyphenated Kebab-Case Naming**: Component directories, crate names, package names, and AAC identifiers MUST use hyphenated kebab-case (e.g., `core`, `ingestion-worker`, `design-system`). Underscores are strictly forbidden in spec directory and component names.
11. **Mermaid Diagram Synchronization**: Whenever modifying or removing entity definitions, schemas, or relations in a specification document containing embedded Mermaid diagrams (`flowchart`, `classDiagram`, `sequenceDiagram`), you MUST inspect and update all embedded Mermaid diagrams in the file to maintain complete text-diagram alignment.
13. **Strict Minimal Scope Bounding**: Never generate speculative or un-requested entities, SPI ports, database migrations, or services. Only specify components and use cases explicitly requested by the user.
14. **Mandatory Use-Case Diagrams**: Every use-case specification MUST include a visual Mermaid sequence or flowchart diagram illustrating the exact request/data flow (`API/Controller` -> `Use Case` -> `SPI Ports / Adapters`).
