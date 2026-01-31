# Workspace Navigation Skill

You are working in the **Host UK developer workspace** - a federated monorepo containing 18 Laravel packages.

## Workspace Structure

```
core-devops/                    # You are here (workspace root)
├── .core/
│   ├── workspace.yaml          # Active package config
│   └── plugin/                 # Claude Code integration
├── packages/                   # All packages cloned here
│   ├── core-php/               # Foundation (no deps)
│   ├── core-tenant/            # Multi-tenancy
│   ├── core-admin/             # Admin panel
│   ├── core-api/               # REST API
│   ├── core-mcp/               # MCP server
│   ├── core-agentic/           # AI agents
│   ├── core-bio/               # Product: link-in-bio
│   ├── core-social/            # Product: social scheduling
│   ├── core-analytics/         # Product: analytics
│   ├── core-notify/            # Product: push notifications
│   ├── core-trust/             # Product: social proof
│   ├── core-support/           # Product: helpdesk
│   ├── core-commerce/          # Billing, Stripe
│   ├── core-content/           # CMS
│   ├── core-tools/             # Developer utilities
│   ├── core-uptelligence/      # Server monitoring
│   ├── core-developer/         # Developer portal
│   └── core-template/          # Starter template
└── repos.yaml                  # Package registry
```

## Key Commands

### Workspace-level (run from root)
```bash
core health                     # Quick status: "18 repos │ clean │ synced"
core work                       # Full workflow: status → commit → push
core work --status              # Status table only
core commit                     # Claude-assisted commits for dirty repos
core push                       # Push repos with unpushed commits
core pull                       # Pull repos that are behind
```

### Package-level (run from root, targets active package)
```bash
core php test                   # Run Pest tests in active package
core php lint                   # Run Pint linter in active package
core php dev                    # Start Vite dev server
```

### GitHub integration
```bash
core issues                     # Open issues across repos
core issues --assignee @me      # Issues assigned to you
core reviews                    # PRs needing review
core ci                         # GitHub Actions status
```

### Analysis
```bash
core impact core-php            # Show what depends on core-php
```

## Active Package

The **active package** is configured in `.core/workspace.yaml`. Commands like `core php test` run in the active package when executed from the workspace root.

To check or change the active package:
```bash
# Check current active package
cat .core/workspace.yaml | grep "active:"

# Change active package (edit the file)
# active: core-tenant
```

## Package Types

Defined in `repos.yaml`:
- **foundation**: `core-php` - base framework, zero dependencies
- **module**: Infrastructure packages (tenant, admin, api, mcp, etc.)
- **product**: User-facing apps (bio, social, analytics, etc.)
- **template**: Starter for new projects
- **meta**: This workspace repo (core-devops)

## Working in a Specific Package

When you need to work in a specific package:

1. **Navigate to it**: `cd packages/core-tenant`
2. **Read its CLAUDE.md**: Each package has its own guidance
3. **Run package commands**: `composer test`, `npm run dev`

Or from the workspace root, change the active package in `.core/workspace.yaml`.

## Dependencies

See `repos.yaml` for the full dependency tree. Key relationships:
- `core-php` has no dependencies (foundation)
- `core-tenant`, `core-admin`, `core-api`, `core-mcp` depend on `core-php`
- Products depend on `core-php` and `core-tenant`
- `core-agentic` depends on `core-php`, `core-tenant`, and `core-mcp`

## Tips

1. **Always prefer `core` commands** over raw git/composer when working across repos
2. **Check `core health`** before starting work to see repo status
3. **Use `core impact`** before changing shared packages
4. **Each package has its own CLAUDE.md** with specific guidance
