# Template Setup Guide

You've created a new repo from the **core-devops** template. Follow these steps to customize it.

## Automated Setup

When you first push, the `template-bootstrap.yml` workflow will:
- ✅ Create standard labels (agent workflow, priorities, types)
- ✅ Enable security features (Dependabot, vulnerability alerts)
- ✅ Create a setup checklist issue

## Files to Customize

### Required Changes

| File | Action |
|------|--------|
| `repos.yaml` | Replace with your package registry or delete if single-repo |
| `CLAUDE.md` | Update with your project's architecture and commands |
| `README.md` | Replace with your project description |
| `package.json` | Update name, or delete if not using VitePress |

### Optional Changes

| File | Action |
|------|--------|
| `.coderabbit.yaml` | Customize review instructions for your codebase |
| `.core/workspace.yaml` | Update active package and settings |
| `doc/` | Replace with your documentation |
| `scripts/` | Keep if useful, or replace with your setup scripts |
| `Makefile` | Update targets for your workflow |

### Files to Delete (if not needed)

```bash
# If not using VitePress docs
rm -rf .vitepress doc package.json

# If not a multi-repo workspace
rm -rf packages repos.yaml .core/workspace.yaml

# This file (after reading!)
rm TEMPLATE_SETUP.md
```

## Secrets to Configure

If using the auto-project workflow:
```bash
# Org-level secret (already set if in host-uk org)
gh secret set PROJECT_TOKEN --org YOUR_ORG --visibility all
```

## Branch Strategy

The template uses `dev` as the default branch:
- `dev` - Development (default, PRs merge here)
- `main` - Production releases

To switch to `main`-only:
```bash
gh repo edit --default-branch main
```

## Adding to Org Projects

```bash
# Add repo's issues to a project when labeled
gh workflow run auto-project.yml
```

## Verification Workflow

The template includes the agent verification workflow:
```
agent:ready → agent:wip → agent:review → verified/verify-failed
```

This enforces the rule: **no agent can verify their own work**.

---

Delete this file once setup is complete:
```bash
rm TEMPLATE_SETUP.md && git add -A && git commit -m "chore: complete template setup"
```
