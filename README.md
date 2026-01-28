# Host UK Developer Workspace

This repository bootstraps a complete Host UK development environment.

## Quick Start

```bash
# 1. Clone this repo
git clone git@github.com:host-uk/core-devops.git
cd core-devops

# 2. Check your environment
core doctor

# 3. Clone all packages
core setup

# 4. Start developing
cd packages/core-php
composer install
```

## Prerequisites

Run `core doctor` to check your environment. You'll need:

- **Git** - Version control
- **GitHub CLI** (`gh`) - For issues, PRs, CI status
- **PHP 8.3+** - Laravel packages
- **Composer** - PHP dependencies
- **Node.js 20+** - Frontend builds
- **pnpm** - Package manager (preferred over npm)

Optional but recommended:
- **Claude Code** - AI-assisted development
- **Docker** - For FrankenPHP runtime

## Commands

```bash
core setup              # Clone all repos into packages/
core setup --only foundation,module  # Clone specific types
core doctor             # Check environment health
core doctor --fix       # Attempt to fix issues

# Once set up, standard core commands work:
core health             # Status summary
core work               # Commit and push workflow
core issues             # View GitHub issues
```

## Structure

```
core-devops/
├── packages/           # Cloned repositories (git-ignored)
│   ├── core-php/
│   ├── core-tenant/
│   └── ...
├── repos.yaml          # Package registry
└── README.md
```

## Updating

```bash
core pull               # Pull updates for all repos
core pull --all         # Pull even if not behind
```

## Troubleshooting

**"core: command not found"**
Install the Core CLI from https://github.com/Snider/Core

**"gh: command not found"**
Install GitHub CLI: `brew install gh` then `gh auth login`

**Clone failures**
Check your SSH keys: `ssh -T git@github.com`
