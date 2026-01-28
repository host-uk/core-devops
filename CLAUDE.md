# CLAUDE.md

This file provides guidance to Claude Code when working in the developer workspace.

## What This Is

This is the **developer workspace orchestrator** for Host UK. It contains:
- `repos.yaml` - Registry of all packages
- `packages/` - Directory where repos are cloned (git-ignored)

The actual code lives in `packages/core-*/`. Each has its own CLAUDE.md.

## Commands

```bash
# Workspace setup
core setup              # Clone all repos
core doctor             # Check environment

# Multi-repo operations
core health             # Quick status
core work               # Full workflow
core commit             # Claude-assisted commits
core push               # Push changes
core pull               # Pull updates

# GitHub integration
core issues             # List issues
core reviews            # List PRs
core ci                 # CI status

# Analysis
core impact core-php    # Dependency analysis
```

## Working on Packages

```bash
cd packages/core-php
composer test           # Run tests
composer lint           # Fix style
```

## This Is a Workspace, Not Code

Don't add code here. This repo only contains:
- Configuration files
- The `packages/` directory structure
- Documentation

All actual development happens in `packages/core-*/`.
