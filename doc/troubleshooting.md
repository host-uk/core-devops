# Troubleshooting

Common issues and solutions.

## Installation Issues

### "core: command not found"

The Core CLI isn't installed or not in PATH.

```bash
make install-core
```

Or manually:

```bash
./scripts/install-core.sh
```

### "gh: command not found"

Install GitHub CLI:

```bash
# macOS
brew install gh

# Then authenticate
gh auth login -h github.com -p https -s workflow,repo,read:org,read:project,project
```

### Clone failures

Check your SSH keys:

```bash
ssh -T git@github.com
```

If using HTTPS:

```bash
gh auth setup-git
```

## GitHub Issues

### "refusing to allow an OAuth App to create or update workflow"

Missing `workflow` scope:

```bash
gh auth refresh -h github.com -s workflow
```

### "missing required scopes [read:project]"

Missing project scope:

```bash
gh auth refresh -h github.com -s read:project,project
```

## Workspace Issues

### Tests failing in wrong package

Check the active package in `.core/workspace.yaml`:

```yaml
active: core-php  # Should match the package you're testing
```

### Packages not found

Run setup to clone packages:

```bash
core setup
```

Or clone specific types:

```bash
core setup --only foundation,module
```

## Getting Help

1. Run `core doctor` to check environment
2. Check GitHub issues: https://github.com/host-uk/core-devops/issues
3. Ask in Discord: https://discord.gg/host-uk
