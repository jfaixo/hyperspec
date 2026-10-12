---
name: index-content
description: Updates the repository content indexes.
---

# Repository Content Indexer

Update the repository content indexes.

Indexes are `directory_map.md` files that contain only the folder and files hierarchy tree.

Each entry of the tree is composed of the following elements, on the same line:

- spaces and unicode characters to represent the folder hierarchy
- the name of the folder or file, with a link to it if it's a file
- a dash (`-`) followed by a quick description of the folder or file content

These indexes are used to help browsing the repository content and find relevant information.

## Gotchas
<gotchas>
- All the existing `directory_map.md` files in the root folder and its subfolders must be updated.
- No new `directory_map.md` files should be created. If a `directory_map.md` file does not exist in a folder, the skill should not create one. It should only update existing `directory_map.md` files.
- Paths must be workspace relative and use forward slashes (`/`) as separators, regardless of the operating system.
- If an `directory_map.md` file is encountered in a subfolder, the skill will stop the recursion for the current index. It will then update the subfolder's `directory_map.md` file, leveraging a subagent.
- The folder hierarchy should be represented as a tree structure using indentation and unicode characters to represent branches (e.g., `├──`, `└──`, `│`).
- End each line with a double space to ensure proper line breaks in markdown.
- Use the non breaking space character (` `) for indentation to ensure that the formatting is preserved when rendered in markdown.
</gotchas>