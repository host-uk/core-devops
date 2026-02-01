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
```

### Windows Setup

The `core` CLI is not yet available on Windows. Use these steps instead:

```powershell
# 1. Install dependencies (PowerShell as Admin)
.\scripts\install-deps.ps1

# 2. Authenticate GitHub CLI
gh auth login -h github.com -p https -s workflow,repo,read:org,read:project,project

# 3. Clone all repos
.\scripts\clone-repos.ps1

# 4. Enable PHP extensions (edit C:\tools\php84\php.ini, uncomment these):
#    extension=curl
#    extension=fileinfo
#    extension=mbstring
#    extension=openssl
#    extension=pdo_sqlite

# 5. Install and test a package
cd packages/core-php
composer install
composer test
```

### Environment Variables (macOS/Linux)

For `install-core.sh`:
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

## Local Package Linking

Most packages depend on `host-uk/core` (the published name of `core-php`). Since these are private packages, `composer install` fails unless you configure local path repositories.

### Quick Setup

```bash
# macOS/Linux - setup all packages
./scripts/setup-local-packages.sh

# Windows (PowerShell)
.\scripts\setup-local-packages.ps1

# Or setup a specific package
./scripts/setup-local-packages.sh core-tenant
```

### Installing Dependencies

After running the setup script, install dependencies using the local config:

```bash
# macOS/Linux
cd packages/core-tenant
COMPOSER=composer.local.json composer install

# Windows (PowerShell)
cd packages\core-tenant
$env:COMPOSER='composer.local.json'; composer install
```

### How It Works

The setup script generates a `composer.local.json` for each package by merging the original `composer.json` with path repositories pointing to sibling packages:

```json
{
    "name": "host-uk/core-tenant",
    "require": {"host-uk/core": "dev-main"},
    "repositories": [
        {"type": "path", "url": "../core-php", "options": {"symlink": true}},
        {"type": "path", "url": "../core-tenant", "options": {"symlink": true}}
    ]
}
```

When Composer sees `host-uk/core` as a requirement, it resolves it to `../core-php` (symlinked) instead of trying to fetch from Packagist.

### Packages That Need This

Only `core-php` can be tested without local linking (it has no `host-uk/*` dependencies). All other packages require this setup:

- core-tenant, core-admin, core-api, core-mcp, core-agentic
- core-bio, core-social, core-analytics, core-notify, core-trust, core-support
- core-commerce, core-content, core-tools, core-uptelligence, core-developer

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

### Windows-Specific

- **"openssl extension is required"** → Enable extensions in `C:\tools\php84\php.ini` (see setup above)
- **"composer: command not found"** → Use PowerShell, not Git Bash: `powershell -Command "composer install"`
- **core CLI not available** → Use `.\scripts\clone-repos.ps1` and work directly with composer

## This Repo's Scope

Don't add application code here. This repo only contains:
- `repos.yaml` - Package registry with dependencies
- `scripts/` - Cross-platform setup scripts (install-deps, install-core, clone-repos, setup-local-packages)
- `Makefile` - Setup orchestration
- `.core/` - Workspace configuration and Claude Code integration
