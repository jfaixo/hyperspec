---
trigger: always_on
---
## Enforce Exhaustive Verification & Component Integration Testing

Before declaring any feature implementation, specification alignment, or refactoring task complete, you MUST execute empirical verification across all affected software layers and component boundaries:

1. **Exhaustive Integration Test Coverage**: Never declare a task complete based on superficial file edits alone. Every newly introduced or modified component boundary (e.g. HTTP APIs, frontend state management, event distribution channels, auth middleware, SPI adapters, or data persistence) MUST be covered by explicit unit/integration test cases verifying both success paths and error states.
2. **Empirical Runtime Execution**: Every component contract and dependency integration MUST be verified through real code execution (e.g. running unit/integration test suites, build checks, and linter runs) to catch runtime failures, broken API contracts, missing dependencies, or unhandled edge cases prior to declaring success.
3. **Multi-Layer Quality Checks**: Always execute full workspace and package verification commands before reporting completion:
   - Type checking
   - Linter static analysis
   - Integration test suites
   - E2E test suites