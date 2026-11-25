# GitHub CLI (`gh`) Issue Operations

## List / Search Issues

```bash
gh issue list --limit <number>
gh issue list --search "<query>"
```

## View an Issue

```bash
gh issue view <issue-number-or-url>
```

## Create an Issue

Pass the markdown body from a file or stdin (`--body-file -`):

```bash
gh issue create \
  --title "<title>" \
  --body-file <path-or-dash>
```

## Edit an Issue

```bash
gh issue edit <issue-number-or-url> \
  --title "<new-title>" \
  --body-file <path-or-dash>
```

## Optional Flags

Can be discovered running `gh issue <command> --help`.
