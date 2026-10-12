---
trigger: always_on
tags: opinionated
---

## Enforce Explicit Identifier Naming (No Abbreviation)

Never use abbreviated variable, function parameter, struct field, or constant names anywhere in the codebase. All identifiers MUST be clear, explicit, and self-documenting.

### 1. Mandatory Explicit Names

- Use `tenant_repository` instead of `tenant_repo`
- Use `authenticated_user` instead of `auth_user`
- Use `request` instead of `req`
- Use `response` instead of `res` or `resp`
- Use `error` instead of `err`
- Use `content_type` instead of `ct`
- Use `instant` instead of `inst`
- Use `authorization_url` instead of `auth_url`
- Use `authorization_header` instead of `auth_header`

### 2. Explicit Layer-Suffixed Entity Naming

- Always explicitly name domain entities, DTOs, and data transfer structs suffixed with their layer context and purpose.
- Do NOT use generic abbreviations or generic suffixes like `Dto` (e.g., use `TenantUserRoleApiResponse` or `TenantUserRoleApiRequest` instead of `TenantUserRoleDto`, use `UserCoreEntity` instead of `User`).
- Examples:
  - Use `TenantUserRoleApiEntity` instead of `TenantUserRoleDto`
  - Use `UserCoreEntity` instead of `User` in core context when disambiguating layer scope

### 3. General Requirement

Avoid single-letter variables (e.g. `c`, `e`, `q`, `r`, `t`, `v`, `x`) except in standard mathematical formulas or short iterator closures where context is unambiguous.
