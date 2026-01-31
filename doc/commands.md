# Commands Reference

All `core` CLI commands available in the workspace.

## Workspace Commands

### `core health`

Quick status summary of all repos.

```bash
core health
# Output: 18 repos │ 2 dirty │ synced
```

### `core work`

Full workflow: status → commit → push.

```bash
core work              # Interactive
core work --status     # Status table only
```

### `core commit`

Claude-assisted commits for dirty repos.

```bash
core commit            # Interactive
core commit --all      # Commit all without prompting
```

### `core push`

Push repos with unpushed commits.

```bash
core push              # Interactive
core push --force      # Push without confirmation
```

### `core pull`

Pull repos that are behind.

```bash
core pull              # Interactive
core pull --all        # Pull all repos
```

## GitHub Integration

### `core issues`

List open issues across repos.

```bash
core issues                    # All open issues
core issues --assignee @me     # Assigned to you
```

### `core reviews`

List PRs needing review.

```bash
core reviews
```

### `core ci`

GitHub Actions workflow status.

```bash
core ci
```

## Analysis

### `core impact`

Show what depends on a package.

```bash
core impact core-php
```

## Package Commands

### `core php test`

Run Pest tests in the active package.

```bash
core php test
core php test --filter=ClassName
```

### `core php lint`

Run Pint linter in the active package.

```bash
core php lint
```

### `core php dev`

Start Vite dev server in the active package.

```bash
core php dev
```

## Setup Commands

### `core setup`

Clone repos into the workspace.

```bash
core setup                           # Default (foundation + module)
core setup --only foundation,module  # Specific types
```

### `core doctor`

Check environment health.

```bash
core doctor           # Check only
core doctor --fix     # Attempt to fix issues
```
