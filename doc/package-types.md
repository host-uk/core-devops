# Package Types

Host UK packages are organised into types based on their purpose.

## Foundation

Base framework with no dependencies.

| Package | Description |
|---------|-------------|
| `core-php` | Event-driven modules, lifecycle management |

## Modules

Infrastructure services that extend the foundation.

| Package | Description | Dependencies |
|---------|-------------|--------------|
| `core-tenant` | Multi-tenancy, workspaces, users | core-php |
| `core-admin` | Admin panel, Livewire, Flux UI | core-php |
| `core-api` | REST API, rate limiting, webhooks | core-php, core-tenant |
| `core-mcp` | Model Context Protocol server | core-php |
| `core-agentic` | AI agent orchestration | core-php, core-tenant, core-mcp |
| `core-commerce` | Billing, subscriptions, Stripe | core-php, core-tenant |
| `core-content` | CMS, pages, blog posts | core-php, core-tenant |
| `core-tools` | Developer utilities | core-php |
| `core-uptelligence` | Server monitoring | core-php, core-tenant |
| `core-developer` | Developer portal, OAuth | core-php, core-tenant, core-api |

## Products

User-facing applications.

| Package | Description | Domain |
|---------|-------------|--------|
| `core-bio` | Link-in-bio pages | bio.host.uk.com |
| `core-social` | Social media scheduling | social.host.uk.com |
| `core-analytics` | Privacy-first analytics | analytics.host.uk.com |
| `core-notify` | Push notifications | notify.host.uk.com |
| `core-trust` | Social proof widgets | trust.host.uk.com |
| `core-support` | Helpdesk, ticketing | - |

## Templates

Starter templates for new projects.

| Package | Description |
|---------|-------------|
| `core-template` | Starter template |

## Meta

Workspace and tooling repos.

| Package | Description |
|---------|-------------|
| `core-devops` | This workspace |
| `core` | Go CLI and framework |
