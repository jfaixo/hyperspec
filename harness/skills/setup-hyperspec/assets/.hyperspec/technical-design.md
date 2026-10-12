---
hyperspec-version: 0.3.0
tags: opinionated
---

# Technical Design

Define system architecture and component software design adhering to C4-style diagrams and micromodule (µmod) principles.

## 1. System Architecture Diagrams

Structure architecture diagrams hierarchically:

- **Logical Diagram:** Model the high-level system components and their relationships in a single overarching diagram whenever possible.
- **Technical Diagrams:** Zoom into specific areas or concerns of the logical diagram. Each technical diagram MUST explicitly reference and contain the corresponding logical components it details. Split technical diagrams across specific concerns when complexity grows.

## 2. Interface-Driven Design

Specify all public interfaces exposed by components and µmods technically:

- **Explicit Interface Contracts:** Every public interface exposed by a component or µmod MUST be technically specified.
- **Strict Decoupling:** Components and µmods MUST implement these specified interfaces.
- **Dependency on Interfaces Only:** Components and µmods MUST depend exclusively on public interfaces of other components or µmods, never on their concrete implementations.

## 3. Software Design: µmods (µmod)

Decompose component software designs into independent modules adhering to µmod philosophy:

- **Dedicated µmods Specification:** Group all µmod designs for a component into a dedicated µmods specification file (e.g. `specs/02-components/<component>/µmods/spec.md`), tailored for agent consumption.
- **Single Concern:** Each µmod addresses exactly one concern (Separation of Concerns).
- **Isolated Unit Testing:** Each µmod owns a dedicated unit test suite executable independently from all other modules.
- **Agent Operation:** Assign one or more µmods to dedicated subagents for implementation and validation using their section in the component's µmods `spec.md`.
- **Tiered Validation Lifecycle:**
  1. **Unit Validation:** The assigned agent validates the µmod against its public interface using its isolated unit test suite.
  2. **Integration Validation:** The calling agent runs integration tests across interacting µmods once their public interfaces pass unit validation.
  3. **E2E Validation:** The top-level orchestrator runs end-to-end (E2E) tests across the entire integrated system.