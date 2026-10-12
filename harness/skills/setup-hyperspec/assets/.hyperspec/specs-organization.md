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

### Recommended Layout

A recommended layout to maintain organization is:

- **Master product brief:** Located under `specs/spec.md`, provide a high level overview of the specified solution or product.
- **Cross-Cutting Concerns:** Located under `specs/01-cross-cutting/`, contains the high level technical architecture design (logical architecture, technical architecture, etc), high level functional specs (domain model, glossary, etc), or specifications that span over two or more components (authentication, general coding style, etc). These can be further organized as `specs/01-cross-cutting/{technical,functional}` for example.
- **Component-Specific Specs:** Located under `specs/02-components/<component>/` for each individual product component (eg. backend, frontend, iac, worker...).
- create a `specs/directory_map.md` file for easing the specs navigation

## Gotchas
<gotchas>
- Refer to `technical-design.md` when creating or updating technical specs.
</gotchas>