---
hyperspec-version: 0.3.0
tags: opinionated
---

# Specifications Organization

This document outlines how specifications must be structured and organized within `/specs/`.

## 1. Directory Separation

- **Specifications (`specs/`):** All specification documents must reside strictly inside the `specs/` directory. Each specification file must be a markdown file, organized in the specs directory tree (see below). Each directory must contain a master spec named `spec.md`.
- **Codebase:** Any other directories and files in the repository are reserved for code, configurations, or other assets.

## 2. Organization Principles

Specs can be organized in multiple ways depending on the complexity and use case of the topic:

- **Hierarchical:** By decomposition, breaking down a large spec into sub-specs in subdirectories.
- **By Aggregation:** Creating a master spec that links to multiple smaller specs.
- **By Hyperlinking:** Leveraging markdown links to reference related specs.

## 3. Specs Layout

The layout to maintain organization is:

- **Master brief:** Located under `specs/spec.md`, provide a high level overview of the specified solution.
- **Cross-Cutting Concerns:** Located under `specs/01-cross-cutting/`, contains the high level technical architecture design (logical architecture, technical architecture, etc), high level functional specs (domain model, glossary, etc), or specifications that span over two or more components (authentication, general coding style, etc). These can be further organized as `specs/01-cross-cutting/{technical,functional}` for example.
- **Component-Specific Specs:** Located under `specs/02-components/<component>/` for each individual component (eg. backend, frontend, iac, worker...).
- create a `specs/directory_map.md` file for easing the specs navigation

## 4. Technical Design

Define system architecture and component software design adhering to C4-style diagrams and principles.

### 4.1. System Architecture Diagrams

Structure architecture diagrams hierarchically:

- **Logical Diagram:** Located in `specs/01-cross-cutting/technical/logical-architecture.md`. Model the high-level system components and their relationships in a single overall Mermaid diagram whenever possible.
- **Technical Diagrams:** Located in `specs/01-cross-cutting/technical/technical-architecture.md`. Zoom into specific areas or concerns of the logical diagram. Each technical diagram MUST explicitly reference and contain the corresponding logical components (from the Logical Diagram) it details. Split technical diagrams across specific concerns when complexity grows.

### 4.2. Repository structure

Specify in `specs/01-cross-cutting/technical/repository-housekeeping.md` the expected layout of the repository, along with the git branching strategy.

### 4.3. Testing and feedback loop

Specify in `specs/01-cross-cutting/technical/testing-and-feedback-loop.md` what are the different kind of tests to run in order to assess the proper functioning of the system (e2e tests, integration tests, unit tests). This document must specify:

- how to run the different tests kinds for components.
- how the tests are organized and executed (testing environment, tooling,...).

## Operational Constraints

- Specs must be exhaustively edited: all the downstream impacts must be jointly edited.
- The git branching strategy must be explicitly specified. Otherwise, this is a blocking open point to raise.
- The way of implementing and running tests must be explicitly specified. Otherwise, these are blocking open points to raise.
