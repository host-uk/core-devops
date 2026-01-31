# Host UK Developer Workspace

This repository is the **unified entry point** for Host UK development. One command sets up your entire environment.

## Quick Start

```bash
git clone git@github.com:host-uk/core-devops.git && cd core-devops && make setup
```

**Windows (PowerShell as Admin):**
```powershell
git clone git@github.com:host-uk/core-devops.git; cd core-devops; .\scripts\install-deps.ps1; .\scripts\install-core.ps1; core setup
```

## What Happens

`make setup` does three things:

1. **Installs dependencies** - PHP 8.3+, Composer, Node 20+, pnpm, GitHub CLI
2. **Installs the `core` CLI** - Multi-repo management tool
3. **Clones all packages** - Into `packages/` (foundation and modules by default)

After setup, run `core doctor` to verify everything is working.

## What's Next

You're now ready to develop. The workspace starts with `core-php` as the active package.

```bash
# Check your environment
core doctor

# See workspace status
core health

# Run tests in the active package (core-php)
core php test

# Switch to a different package
# Edit .core/workspace.yaml and change "active: core-tenant"
```

To work directly in a package:
```bash
cd packages/core-php
composer install
composer test
```

## Commands

### Workspace-level
```bash
core health             # Status summary: "18 repos │ clean │ synced"
core work               # Full workflow: status → commit → push
core work --status      # Status table only
core commit             # Claude-assisted commits for dirty repos
core push               # Push repos with unpushed commits
core pull               # Pull repos that are behind
```

### Active package
```bash
core php test           # Run Pest tests
core php lint           # Run Pint linter
core php dev            # Start Vite dev server
```

### GitHub integration
```bash
core issues             # Open issues across repos
core issues --assignee @me
core reviews            # PRs needing review
core ci                 # GitHub Actions status
```

### Analysis
```bash
core impact core-php    # Show what depends on core-php
```

## Structure

```
core-devops/
├── .core/              # Workspace configuration
│   ├── workspace.yaml  # Active package, paths
│   └── plugin/         # Claude Code integration
├── packages/           # Cloned repositories (git-ignored)
│   ├── core-php/       # Foundation framework
│   ├── core-tenant/    # Multi-tenancy
│   ├── core-admin/     # Admin panel
│   └── ...
└── repos.yaml          # Package registry
```

## Prerequisites

Run `core doctor` to check your environment. Required:

- **Git** - Version control
- **GitHub CLI** (`gh`) - Issues, PRs, CI status
- **PHP 8.3+** - Laravel packages
- **Composer** - PHP dependencies
- **Node.js 20+** - Frontend builds
- **pnpm** - Package manager

Optional:
- **Claude Code** - AI-assisted development
- **Docker** - For FrankenPHP runtime

## Package Types

Defined in `repos.yaml`:

| Type           | Packages                                                   | Description                      |
|----------------|------------------------------------------------------------|---------------------------------|
| **foundation** | `core-php`                                                 | Base framework, zero dependencies |
| **module**     | `core-tenant`, `core-admin`, `core-api`, `core-mcp`, etc.  | Infrastructure                  |
| **product**    | `core-bio`, `core-social`, `core-analytics`, etc.          | User-facing apps                |
| **template**   | `core-template`                                            | Starter for new projects        |
| **meta**       | `core-devops`                                              | This workspace repo             |

By default, `core setup` clones foundation and module packages. To clone specific types:
```bash
core setup --only foundation,module,product
```

## Troubleshooting

**"core: command not found"**
```bash
make install-core
```

**"gh: command not found"**
```bash
brew install gh && gh auth login -h github.com -p https -s workflow,repo,read:org
```

**"refusing to allow an OAuth App to create or update workflow"**
```bash
gh auth refresh -h github.com -s workflow
```

**Clone failures**
```bash
ssh -T git@github.com  # Verify SSH keys
```

**Missing dependencies**
```bash
core doctor --fix
```

## Documentation

- **This repo's CLAUDE.md** - Guidance for Claude Code in the workspace
- **repos.yaml** - Full package registry with dependencies
- **`.core/docs/core-folder-spec.md`** - Specification for `.core/` folders

Each package in `packages/` has its own CLAUDE.md with package-specific guidance.
