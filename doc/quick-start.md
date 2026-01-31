# Quick Start

Get a complete Host UK development environment in under 5 minutes.

## Prerequisites

- Git
- GitHub CLI (`gh`)
- SSH key configured with GitHub

## Installation

### macOS / Linux

```bash
git clone git@github.com:host-uk/core-devops.git
cd core-devops
make setup
```

### Windows (PowerShell as Admin)

```powershell
git clone git@github.com:host-uk/core-devops.git
cd core-devops
.\scripts\install-deps.ps1
.\scripts\install-core.ps1
core setup
```

## What Happens

`make setup` does three things:

1. **Installs dependencies** - PHP 8.3+, Composer, Node 20+, pnpm, GitHub CLI
2. **Installs the `core` CLI** - Multi-repo management tool
3. **Clones all packages** - Into `packages/` (foundation and modules by default)

## Verify Installation

```bash
core doctor
```

This checks that all required tools are installed and configured.

## Next Steps

```bash
# See workspace status
core health

# Run tests in the active package
core php test

# Work on a specific package
cd packages/core-php
composer test
```

## Troubleshooting

See the [Troubleshooting Guide](/troubleshooting) for common issues.
