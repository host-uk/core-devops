# Package Status Skill

Show the status of all packages in the Host UK workspace.

## Quick Status

Run from workspace root:

```bash
core health
```

Output example:
```
18 repos │ 2 dirty │ 1 behind │ synced
```

## Detailed Status

For a full status table:

```bash
core work --status
```

Output shows:
- Package name
- Git status (clean/dirty/staged)
- Branch and tracking
- Ahead/behind remote

## Check Specific Package

```bash
cd packages/core-php
git status
```

Or check all dirty repos:

```bash
core work --status | grep -v "clean"
```

## Common Statuses

| Status | Meaning | Action |
|--------|---------|--------|
| `clean` | No changes | Ready to work |
| `dirty` | Uncommitted changes | Commit with `core commit` |
| `ahead` | Local commits to push | Push with `core push` |
| `behind` | Remote has new commits | Pull with `core pull` |
| `diverged` | Both ahead and behind | Manual merge needed |

## Workflow Commands

```bash
core work                   # Full workflow: status → commit → push
core commit                 # Commit dirty repos (Claude-assisted)
core push                   # Push repos with unpushed commits
core pull                   # Pull repos that are behind
```

## GitHub Status

```bash
core ci                     # GitHub Actions status
core issues                 # Open issues across repos
core reviews                # PRs needing review
```
