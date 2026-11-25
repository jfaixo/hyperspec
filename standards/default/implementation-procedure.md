---
hyperspec-version: 0.3.0
tags: opinionated
---

# Implementation Procedure

## 1. Architectural Principles (Dependency Inversion)

Apply the **Dependency Inversion Principle (DIP)** across every component and internal module:

- **API (Inbound Contract)**: Expose explicit public entrypoints, domain types, and behaviors matching the specification. Keep internal helpers, data structures, and module details private.
- **SPI (Outbound Contract)**: Define interfaces/ports owned by the component or module for every external dependency (storage, network, clock, external services, peer components).
- **Inversion & Wiring**: Depend strictly on API/SPI abstractions inside domain and application logic. Place concrete SPI implementations in outer adapters and bind them at the composition root.

## 2. Public-API TDD Recipe

Implement each component and internal module via strict **Red -> Green -> Refactor** cycles driven exclusively from the public API:

1. **Define Contracts**: Create or update the public API and SPI abstractions derived from the specs and AACs.
2. **Red (Public API Tests)**: Write failing tests exclusively against the component or module **public API** (one dedicated test per AAC, covering success and error paths).
   - Provide **stubs** (in-memory fakes or deterministic stubs) for all SPIs.
   - **Prohibited**: Never write tests directly against internal, private, or low-level functions; exercise internal logic exclusively through the public API.
3. **Green (Minimal Implementation)**: Implement the minimal production logic across modules to pass the failing public API tests.
4. **Refactor**: Decompose cohesive internal modules, remove duplication, and refine clarity while keeping every public API test green.
5. **Compose & Verify**: Wire concrete SPI adapters at the composition root and execute full test and check suites.
