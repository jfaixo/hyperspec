---
name: conversation-post-mortem
description: Run a post mortem on a completed conversation to identify AI struggles, propose mitigations, and update instructions to improve future conversations.
disable-model-invocation: true
---

# Conversation Post Mortem Skill

## Execution Role
Run a post mortem on a completed conversation to identify AI struggles, propose mitigations, and update skills to improve future interactions.

## Operational Constraints

- Thoroughly review the entire conversation log before acting
- Provide concrete, actionable mitigation proposals
- **DO NOT** update any skills, or files without explicit user validation
- Ensure any updates align with existing architectural principles and repository guidelines

## Procedure

### 1. Review and Extract Pain Points

- Thoroughly review the conversation history from start to finish.
- Identify all instances where I struggled (e.g., misusing tools, making incorrect assumptions, failing to follow instructions, or needing user corrections).
- Create a list of these specific pain points.

### 2. Prioritize

- Review the extracted pain points and prioritize them based on their impact on the conversation flow and how frequently they occurred.
- Focus on issues that caused the most friction or wasted the most time.

### 3. Propose Mitigations

- For each prioritized item, propose up to **3 concrete mitigation procedures**.
- A mitigation procedure could be:
  - Updating an existing `SKILL.md` or any coding agent related file.
  - Creating a new skill.
  - Adding or amending a linked documentation file in the repository.
  - Creating a new Knowledge entry (in `.agents/knowledge`).

### 4. User Validation

- Present the prioritized list of struggles and the proposed mitigations to the user in a clear, structured format.
- **STOP execution and wait.** Ask the user to assess the options and tell you which mitigation procedure(s) they want to keep. Do not proceed to the next step until the user has validated their choices.

### 5. Memorize and Execute

- Once the user validates specific mitigation procedures, immediately execute them.
- Apply the changes exactly as agreed upon (updating skills, documentation, etc.).
- Provide a brief summary of the applied updates to close the post-mortem session.

## Gotchas
<gotchas>
- Be concise but complete when extracting pain points
- Make mitigations durable (e.g., updating files) rather than temporary
- Always prioritize user consent before modifying agent instructions
</gotchas>

## Output Schema
<output_contract>
Upon completing, emit a report:

### Post Mortem Summary
- **Pain point #1**: [MITIGATED|NOT-MITIGATED]
  - `Mitigation: [Mitigation type (skill, documentation, etc.)]`
  - `Summary: [Summary of the pain point]`
  - `Resolution: [What was done to mitigate it]`
</output_contract>