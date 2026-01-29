# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

This is the **developer workspace orchestrator** for Host UK - a federated monorepo containing 18 Laravel packages. This repo contains only configuration and setup scripts; actual code lives in `packages/core-*/`, each with its own CLAUDE.md.

## Initial Setup

```bash
# One-liner (macOS/Linux)
git clone git@github.com:host-uk/core-devops.git && cd core-devops && make setup

# Or step by step
make install-deps       # Install go, gh, php, node, pnpm
make install-core       # Build/install core CLI to ~/.local/bin
make clone              # Clone all repos into packages/
```

## Commands

```bash
# Environment
make setup              # Full setup (deps + core + clone)
core doctor             # Check environment (requires: git, gh, php 8.3+, composer, node 20+, pnpm)
core doctor --fix       # Attempt to fix issues

# Multi-repo workflow
core health             # Quick status summary
core work               # Full workflow: status → commit → push
core work --status      # Status table only (no commit/push)
core commit             # Claude-assisted commits for dirty repos
core commit --all       # Commit all without prompting
core push               # Push repos with unpushed commits
core pull               # Pull repos that are behind

# GitHub integration (requires gh CLI)
core issues             # List open issues across repos
core issues --assignee @me
core reviews            # List PRs with review status
core ci                 # GitHub Actions workflow status

# Analysis
core impact core-php    # Show what depends on core-php
```

## Working on Packages

```bash
cd packages/core-php
composer install
composer test           # Run Pest tests
composer lint           # Fix code style (Pint)
npm run dev             # Vite dev server (if has frontend)
```

## Package Types (repos.yaml)

| Type | Examples | Purpose |
|------|----------|---------|
| foundation | core-php | Base framework (no dependencies) |
| module | core-tenant, core-admin, core-api, core-mcp | Infrastructure services |
| product | core-bio, core-social, core-analytics | User-facing applications |
| template | core-template | Starter for new projects |
| meta | core-devops | This workspace repo |

## This Is a Workspace, Not Code

Don't add code here. All actual development happens in `packages/core-*/`.

This repo manages:
- `repos.yaml` - Package registry with dependencies
- `packages/` - Cloned repositories (git-ignored)
- `scripts/` - Setup scripts for macOS/Linux/Windows
