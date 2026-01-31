# Switch Package Skill

Switch the active package for the Host UK workspace.

## Usage

To switch the active package, edit `.core/workspace.yaml` and change the `active` field:

```yaml
# .core/workspace.yaml
active: core-tenant  # Change this to the desired package
```

## Available Packages

| Package | Type | Description |
|---------|------|-------------|
| `core-php` | foundation | Core PHP framework |
| `core-tenant` | module | Multi-tenancy, workspaces |
| `core-admin` | module | Admin panel, Livewire |
| `core-api` | module | REST API, rate limiting |
| `core-mcp` | module | MCP server framework |
| `core-agentic` | module | AI agent orchestration |
| `core-bio` | product | Link-in-bio pages |
| `core-social` | product | Social media scheduling |
| `core-analytics` | product | Privacy-first analytics |
| `core-notify` | product | Push notifications |
| `core-trust` | product | Social proof widgets |
| `core-support` | product | Helpdesk, tickets |
| `core-commerce` | module | Billing, Stripe |
| `core-content` | module | CMS, pages, blog |
| `core-tools` | module | Developer utilities |
| `core-uptelligence` | module | Server monitoring |
| `core-developer` | module | Developer portal |
| `core-template` | template | Starter template |

## After Switching

After changing the active package:

1. Commands like `core php test` will target the new package
2. Read the package's CLAUDE.md for specific guidance: `packages/{package}/CLAUDE.md`
3. Install dependencies if needed: `cd packages/{package} && composer install`

## Quick Switch (CLI - Future)

Once `core workspace` commands are implemented:

```bash
core workspace active core-tenant    # Switch to core-tenant
core workspace active               # Show current active package
```
