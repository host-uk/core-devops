# repos.yaml

The package registry defining all repositories in the workspace.

## Format

```yaml
version: 1
org: host-uk
base_path: ./packages

repos:
  core-php:
    type: foundation
    description: Core PHP framework
    docs: true
    ci: github-actions

  core-tenant:
    type: module
    depends_on: [core-php]
    description: Multi-tenancy, workspaces

defaults:
  ci: github-actions
  license: EUPL-1.2
  branch: main
```

## Fields

### Repository Fields

| Field | Type | Description |
|-------|------|-------------|
| `type` | string | Package type (see below) |
| `depends_on` | array | Dependencies on other packages |
| `description` | string | Short description |
| `docs` | boolean | Has documentation |
| `ci` | string | CI system (github-actions) |
| `domain` | string | Production domain (products only) |
| `clone` | boolean | Whether to clone (default: true) |

### Package Types

| Type | Purpose | Examples |
|------|---------|----------|
| `foundation` | Base framework, no dependencies | core-php |
| `module` | Infrastructure services | core-tenant, core-admin |
| `product` | User-facing applications | core-bio, core-social |
| `template` | Starter templates | core-template |
| `meta` | Workspace repos | core-devops |

## Using with CLI

```bash
# Clone specific types
core setup --only foundation,module

# Show what depends on a package
core impact core-php
```

## Dependency Graph

The `depends_on` field creates a dependency graph:

```
core-php (foundation)
├── core-tenant
├── core-admin
├── core-api
│   └── core-developer
└── core-mcp
    └── core-agentic
```

Products depend on both `core-php` and `core-tenant`.
