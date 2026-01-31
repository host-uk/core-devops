# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

This is the **developer workspace orchestrator** for Host UK - a federated monorepo containing 18 Laravel packages. This repo contains only configuration and setup scripts; actual code lives in `packages/core-*/`, each with its own CLAUDE.md.

For coding standards, architecture patterns, and Laravel-specific guidance, see the parent `/Users/snider/Code/host-uk/CLAUDE.md`.

## .core/ Folder System

This workspace uses a `.core/` folder for configuration and Claude Code integration:

```
.core/
├── workspace.yaml           # Active package, paths, settings
├── plugin/
│   ├── plugin.json          # Claude Code manifest
│   ├── skills/              # Context-aware skills
│   │   ├── workspace.md     # Multi-repo navigation
│   │   ├── switch-package.md
│   │   └── package-status.md
│   └── hooks/               # Command hooks
│       └── prefer-core.sh   # Suggest core CLI commands
└── docs/
    └── core-folder-spec.md  # Full .core/ specification
```

### Active Package

The **active package** in `.core/workspace.yaml` determines where unified commands run:

```yaml
active: core-php  # Commands like `core php test` target this package
```

When working from the workspace root, change this to work on a different package without navigating directories.

### Skills

Skills in `.core/plugin/skills/` provide context-aware guidance:
- **workspace.md** - Multi-repo navigation and commands
- **switch-package.md** - How to change the active package
- **package-status.md** - Checking status across repos

### Specification

See `.core/docs/core-folder-spec.md` for the full specification that each package should follow.

## Initial Setup

```bash
# macOS/Linux
git clone git@github.com:host-uk/core-devops.git && cd core-devops && make setup

# Windows (PowerShell as Admin)
.\scripts\install-deps.ps1 && .\scripts\install-core.ps1 && core setup
```

Environment variables for `install-core.sh`:
- `INSTALL_DIR` - Binary location (default: `~/.local/bin`)
- `BUILD_FROM_SOURCE` - `true`, `false`, or `auto` (default: `auto`, tries binary then builds)

## Commands

### Workspace-level (from root)
```bash
# Setup & diagnostics
make setup              # Full setup (deps + core CLI + clone repos)
core doctor             # Check environment health
core doctor --fix       # Attempt to fix issues

# Multi-repo workflow
core health             # Quick status summary
core work               # Full workflow: status → commit → push
core work --status      # Status table only
core commit             # Claude-assisted commits for dirty repos
core commit --all       # Commit all without prompting
core push               # Push repos with unpushed commits
core pull               # Pull repos that are behind

# GitHub integration (requires gh CLI)
core issues             # List open issues across repos
core issues --assignee @me
core reviews            # List PRs needing review
core ci                 # GitHub Actions workflow status

# Dependency analysis
core impact core-php    # Show what depends on core-php
```

### Active package (from root)
```bash
core php test           # Run Pest tests in active package
core php lint           # Run Pint linter in active package
core php dev            # Start Vite dev server
```

### Direct package work
```bash
cd packages/core-php
composer install && composer test           # Run Pest tests
composer test -- --filter=ClassName         # Single test
./vendor/bin/pint --dirty                   # Format changed files
```

## Package Switching Workflow

To work on a different package without navigating:

1. Edit `.core/workspace.yaml`:
   ```yaml
   active: core-tenant
   ```

2. Run commands from workspace root:
   ```bash
   core php test    # Now runs in core-tenant
   ```

3. Read the package's CLAUDE.md:
   ```bash
   cat packages/core-tenant/CLAUDE.md
   ```

## Package Types

Defined in `repos.yaml`:
- **foundation**: `core-php` - base framework, no dependencies
- **module**: `core-tenant`, `core-admin`, `core-api`, `core-mcp` - infrastructure
- **product**: `core-bio`, `core-social`, etc. - user-facing apps
- **template**: `core-template` - starter for new projects
- **meta**: `core-devops` - this workspace repo

## Troubleshooting

- **"core: command not found"** → `make install-core` (builds from https://github.com/host-uk/core)
- **"gh: command not found"** → `brew install gh && gh auth login -h github.com -p https -s workflow,repo,read:org,read:project,project`
- **"refusing to allow..." or "missing required scopes"** → `gh auth refresh -h github.com -s workflow,read:project,project`
- **Clone failures** → `ssh -T git@github.com` to verify SSH keys

## This Repo's Scope

Don't add application code here. This repo only contains:
- `repos.yaml` - Package registry with dependencies
- `scripts/` - Cross-platform setup scripts (install-deps, install-core)
- `Makefile` - Setup orchestration
- `.core/` - Workspace configuration and Claude Code integration
