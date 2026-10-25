---
hyperspec-version: 0.3.0
tags: opinionated
---
# Specifications Organization

This document outlines how specifications must be structured and organized within `/specs/`.

## 1. Directory Separation

- **Specifications (`specs/`):** All specification documents must reside strictly inside the `specs/` directory. Each specification file must be a markdown file named `spec.md`, organized in the directory tree of the product (see below).
- **Codebase:** Any other directories and files in the repository are reserved for code, configurations, or other assets.

## 2. Organization Principles

Specs can be organized in multiple ways depending on the complexity of the topic:

- **Hierarchical:** Breaking down a large spec into sub-specs in subdirectories.
- **By Aggregation:** Creating a master spec that links to multiple smaller specs.
- **By Decomposition:** Starting from a high-level spec and drilling down.

## 3. Specs Layout

The layout to maintain organization is:

- **Master product brief:** Located under `specs/spec.md`, provide a high level overview of the specified solution or product.
- **Cross-Cutting Concerns:** Located under `specs/01-cross-cutting/`, contains the high level technical architecture design (logical architecture, technical architecture, etc), high level functional specs (domain model, glossary, etc), or specifications that span over two or more components (authentication, general coding style, etc). These can be further organized as `specs/01-cross-cutting/{technical,functional}` for example.
- **Component-Specific Specs:** Located under `specs/02-components/<component>/` for each individual product component (eg. backend, frontend, iac, worker...).
- create a `specs/directory_map.md` file for easing the specs navigation

## 4. Technical Design

Define system architecture and component software design adhering to C4-style diagrams and micromodule (µmod) principles.

### 4.1. System Architecture Diagrams

Structure architecture diagrams hierarchically:

- **Logical Diagram:** Located in `specs/01-cross-cutting/technical/logical-architecture.md`. Model the high-level system components and their relationships in a single overarching diagram whenever possible.
- **Technical Diagrams:** Located in `specs/01-cross-cutting/technical/technical-architecture.md`. Zoom into specific areas or concerns of the logical diagram. Each technical diagram MUST explicitly reference and contain the corresponding logical components it details. Split technical diagrams across specific concerns when complexity grows.

### 4.2. Interface-Driven Design

Explicitly specify all public interfaces exposed by components and µmods:

- **Explicit Interface Contracts:** Every public interface exposed by a component or µmod MUST be technically specified.
- **Strict Decoupling:** Components and µmods MUST implement these specified interfaces.
- **Dependency on Interfaces Only:** Components and µmods MUST depend exclusively on public interfaces of other components or µmods, never on their concrete implementations.

### 4.3. Software Design: µmods (µmod)

Decompose component software designs into independent modules adhering to µmod philosophy:

- **Dedicated µmods Specification:** Group all µmod designs for a component into a dedicated µmods specification folder (e.g. `specs/02-components/<component>/µmods/`), tailored for agent consumption. Each µmod must have its own dedicated specification file, while the `µmods/spec.md` file contains the global view of how they are interconnected in the form of a Directed Acyclic Graph, as a Mermaid diagram.
- **Single Concern:** Each µmod addresses exactly one concern (Separation of Concerns). Concerns can be functional (use cases, etc.) or non-functional (repository, logger, etc.)
- **Isolated Unit Testing:** Each µmod owns a dedicated unit test suite executable independently from all other modules. How to launch the tests is documented in `specs/02-components/<component>/µmods/spec.md`.
- **Agent Operation:** Assign one or more µmods to dedicated subagents for implementation and validation using their section in the component's µmods `spec.md`.
- **Tiered Validation Lifecycle:**
  1. **Unit Validation:** The assigned agent validates the µmod against its public interface using its isolated unit test suite.
  2. **Integration Validation:** Run integration tests at the component level across interacting µmods once their public interfaces pass unit validation. How to execute component-level integration tests is documented in `specs/02-components/<component>/spec.md`.
  3. **E2E Validation:** The top-level orchestrator runs end-to-end (E2E) tests across the entire integrated system.

## Operational Constraints
- Specs must be exhaustively edited: all the downstream impacts must be jointly edited. For example, adding a feature to a component must update its µmods.
- The way of implementing and running e2e tests (solution level), integration tests (component level), and unit tests (µmod level) must be explicitly specified. Otherwise, these are blocking open points to raise.
- In component acceptance criteria, each integration test AAC MUST explicitly identify the specific µmods it covers.