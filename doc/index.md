---
layout: home
hero:
  name: "core-devops"
  text: "Developer Workspace"
  tagline: Unified entry point for Host UK development
  actions:
    - theme: brand
      text: Quick Start
      link: /quick-start
    - theme: alt
      text: View on GitHub
      link: https://github.com/host-uk/core-devops
features:
  - title: One Command Setup
    details: Clone and run `make setup` to get a complete development environment with all dependencies.
  - title: Multi-Repo Management
    details: Manage 18+ Laravel packages from a single workspace using the `core` CLI.
  - title: Agentic-First
    details: Designed for AI-assisted development with structured issues and Claude Code integration.
---

# Host UK DevOps

The developer workspace orchestrator for Host UK - a federated monorepo containing 18 Laravel packages.

## What's Included

| Component | Purpose |
|-----------|---------|
| `repos.yaml` | Package registry with dependencies |
| `.core/` | Workspace configuration and Claude Code plugin |
| `scripts/` | Cross-platform setup scripts |
| `Makefile` | Setup orchestration |

## Quick Start

```bash
git clone git@github.com:host-uk/core-devops.git && cd core-devops && make setup
```

## Core CLI

The workspace is managed by the `core` CLI:

```bash
core health          # Status summary
core work            # Commit and push workflow
core issues          # GitHub issues across repos
```

## Next Steps

- [Quick Start Guide](/quick-start) - Get up and running
- [Commands Reference](/commands) - All available commands
- [.core/ Configuration](/core-folder) - Workspace configuration
