# GitLab CLI (`glab`) Issue Operations

## List / Search Issues

```bash
glab issue list
glab issue list --search "<query>"
```

## View an Issue

```bash
glab issue view <issue-id-or-url>
```

## Create an Issue

Pass the markdown body from a file or stdin (`--description-file -`):

```bash
glab issue create \
  --title "<title>" \
  --description-file <path-or-dash> \
  --yes
```

## Update an Issue

```bash
glab issue update <issue-id> \
  --title "<new-title>" \
  --description-file <path-or-dash>
```

## Optional Flags

Can be discovered running `glab issue <command> --help`.

