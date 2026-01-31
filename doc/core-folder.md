# .core/ Folder

The `.core/` folder provides workspace configuration and Claude Code integration.

## Structure

```
.core/
├── workspace.yaml       # Workspace configuration
├── plugin/
│   ├── plugin.json      # Claude Code manifest
│   ├── skills/          # Context-aware skills
│   └── hooks/           # Command hooks
└── docs/
    └── core-folder-spec.md  # Full specification
```

## workspace.yaml

Defines the active package and workspace settings.

```yaml
version: 1

# Active package for `core php test`, etc.
active: core-php

# Default package types for `core setup`
default_only:
  - foundation
  - module

# Paths
packages_dir: ./packages

# Settings
settings:
  suggest_core_commands: true
  show_active_in_prompt: true
```

## Changing Active Package

Edit `.core/workspace.yaml`:

```yaml
active: core-tenant
```

Then commands run from workspace root target that package:

```bash
core php test    # Now runs in core-tenant
```

## Claude Code Plugin

The `plugin/` folder integrates with Claude Code:

### plugin.json

Manifest defining skills and commands.

### skills/

Markdown files providing context-aware guidance:

- `workspace.md` - Multi-repo navigation
- `switch-package.md` - Package switching
- `package-status.md` - Status checking

### hooks/

Shell scripts that run before/after commands:

- `prefer-core.sh` - Suggests `core` commands

## Full Specification

See `.core/docs/core-folder-spec.md` for the complete specification that packages should follow.
