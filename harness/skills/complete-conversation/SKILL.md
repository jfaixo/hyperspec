---
name: complete-conversation
description: Completes a conversation session by committing changes, rebasing and fast-forward merging feature branches onto main when working in a worktree, and cleaning up the local worktree.
---

# Agent Skill: Complete Conversation

Use this skill when the user has approved your changes and requested to complete or wrap up the conversation session.

## Detection: Determine Worktree Context

First, check whether you are running in the main worktree repository or a linked worktree:

1. **Get the current git directory**:
   ```bash
   git rev-parse --git-dir
   ```
2. **Evaluate the context**:
   - **Main worktree**: The command returns `.git` (or an absolute path ending in `/.git` without `worktrees`).
   - **Linked worktree**: The command contains `.git/worktrees/<branch-name>`.

---

## Scenario A: Main Worktree Case

When running directly in the main worktree (`git rev-parse --git-dir` is `.git`):

1. **Verify git status**:
   Ensure all changes are staged and committed:
   ```bash
   git status
   ```
2. **Commit changes**:
   If there are uncommitted or unstaged changes, stage and commit them with a unicode gitmoji conventional commit message (with the emoji first):
   ```bash
   git add -A
   git commit -m "✨ feat(...): ..."
   ```
   No rebasing, merging, or worktree deletion is required.

---

## Scenario B: Linked Worktree Case

When running in a linked worktree (`git rev-parse --git-dir` contains `.git/worktrees/...`):

1. **Verify git status & commit work**:
   Ensure all changes are staged and committed in the current worktree branch:

   ```bash
   git status
   git add -A
   git commit -m "✨ feat(...): ..."
   ```

2. **Rebase onto main**:
   Before integrating into `main`, rebase the feature branch onto `main` so that git history remains strictly linear without any merge commits:

   ```bash
   git fetch origin main # if remote tracking exists
   git rebase main
   ```

   If any conflicts occur, resolve them before proceeding.

3. **Retrieve paths and identifiers**:
   - Current worktree path:
     ```bash
     pwd
     ```
   - Current branch name:
     ```bash
     git rev-parse --abbrev-ref HEAD
     ```
   - Main repository path:
     ```bash
     git rev-parse --git-common-dir
     ```
     _(The main repository path is the parent directory of `--git-common-dir`, e.g. dirname of `.git`)_.

4. **Navigate to the main repository and fast-forward merge**:
   Change directory to the main repository, ensure you are on `main`, and perform a fast-forward only merge to maintain linear history:

   ```bash
   cd <main-repo-path>
   git checkout main
   git merge --ff-only <branch-name>
   ```

5. **Remove the worktree and clean up the feature branch**:
   Delete the worktree directory from the main repository using `git worktree remove`, and optionally delete the merged branch:
   ```bash
   git worktree remove <worktree-path>
   git branch -d <branch-name>
   ```

---

# Gitmojis

- 🎨 - Improve structure / format of the code.
- ⚡️ - Improve performance.
- 🔥 - Remove code or files.
- 🐛 - Fix a bug.
- 🚑️ - Critical hotfix.
- ✨ - Introduce new features.
- 📝 - Add or update documentation.
- 🚀 - Deploy stuff.
- 💄 - Add or update the UI and style files.
- 🎉 - Begin a project.
- ✅ - Add, update, or pass tests.
- 🔒️ - Fix security or privacy issues.
- 🔐 - Add or update secrets.
- 🔖 - Release / Version tags.
- 🚨 - Fix compiler / linter warnings.
- 🚧 - Work in progress.
- 💚 - Fix CI Build.
- ⬇️ - Downgrade dependencies.
- ⬆️ - Upgrade dependencies.
- 📌 - Pin dependencies to specific versions.
- 👷 - Add or update CI build system.
- 📈 - Add or update analytics or track code.
- ♻️ - Refactor code.
- ➕ - Add a dependency.
- ➖ - Remove a dependency.
- 🔧 - Add or update configuration files.
- 🔨 - Add or update development scripts.
- 🌐 - Internationalization and localization.
- ✏️ - Fix typos.
- 💩 - Write bad code that needs to be improved.
- ⏪️ - Revert changes.
- 🔀 - Merge branches.
- 📦️ - Add or update compiled files or packages.
- 👽️ - Update code due to external API changes.
- 🚚 - Move or rename resources (e.g.: files, paths, routes).
- 📄 - Add or update license.
- 💥 - Introduce breaking changes.
- 🍱 - Add or update assets.
- ♿️ - Improve accessibility.
- 💡 - Add or update comments in source code.
- 🍻 - Write code drunkenly.
- 💬 - Add or update text and literals.
- 🗃️ - Perform database related changes.
- 🔊 - Add or update logs.
- 🔇 - Remove logs.
- 👥 - Add or update contributor(s).
- 🚸 - Improve user experience / usability.
- 🏗️ - Make architectural changes.
- 📱 - Work on responsive design.
- 🤡 - Mock things.
- 🥚 - Add or update an easter egg.
- 🙈 - Add or update a .gitignore file.
- 📸 - Add or update snapshots.
- ⚗️ - Perform experiments.
- 🔍️ - Improve SEO.
- 🏷️ - Add or update types.
- 🌱 - Add or update seed files.
- 🚩 - Add, update, or remove feature flags.
- 🥅 - Catch errors.
- 💫 - Add or update animations and transitions.
- 🗑️ - Deprecate code that needs to be cleaned up.
- 🛂 - Work on code related to authorization, roles and permissions.
- 🩹 - Simple fix for a non-critical issue.
- 🧐 - Data exploration/inspection.
- ⚰️ - Remove dead code.
- 🧪 - Add a failing test.
- 👔 - Add or update business logic.
- 🩺 - Add or update healthcheck.
- 🧱 - Infrastructure related changes.
- 🧑💻 - Improve developer experience.
- 💸 - Add sponsorships or money related infrastructure.
- 🧵 - Add or update code related to multithreading or concurrency.
- 🦺 - Add or update code related to validation.
- ✈️ - Improve offline support.
- 🦖 - Code that adds backwards compatibility.
