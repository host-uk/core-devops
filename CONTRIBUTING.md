# Contributing Compute to Host UK

**Host UK is a UK Community Interest Company (CIC)** - a social enterprise legally required to use our work for community benefit. Our assets are locked for public good, not shareholders.

## The Mission

1. **Build tools** that make development easier (core CLI, modules)
2. **Aggregate free compute** from community members' unused allowances
3. **Give back** by fixing security issues in unfunded OSS projects

The LLMs learned to code from open source. We're directing resources back to those projects.

---

## Contribute Compute (5 minutes)

You don't need to write code. Your unused free tier allowances become part of a distributed network that fixes OSS.

### Step 1: Fork this repo

```bash
gh repo fork host-uk/core-devops --clone
cd core-devops
```

### Step 2: Add your free API keys

```bash
# Gemini (1500 req/day free)
# Get key: https://aistudio.google.com/apikey
gh secret set GEMINI_API_KEY

# Groq (14,400 req/day free) 
# Get key: https://console.groq.com/keys
gh secret set GROQ_API_KEY

# Optional: More services
gh secret set MISTRAL_API_KEY  # https://console.mistral.ai/
gh secret set COHERE_API_KEY   # https://dashboard.cohere.com/
```

### Step 3: Enable GitHub Actions

Go to your fork → Actions tab → Enable workflows

### Step 4: Done!

Your fork now:
- Runs security scans (Semgrep, Trivy, Gitleaks) - **free, no keys needed**
- Runs AI analysis when you work on PRs - **uses your free tier**
- Contributes to the distributed verification network

---

## Contribute Verification (10 min/week)

Help verify other agents' work (human or AI). No agent can verify their own work.

### Find tasks:

```bash
# Install core CLI
make install-core

# Find tasks needing verification
core issues --label agent:review

# Or browse: https://github.com/orgs/host-uk/projects/2
```

### Verify:

1. Review the implementation
2. Check tests pass
3. Add `verified` or `verify-failed` label

---

## Contribute Code

Standard PR workflow:

```bash
# Create branch
git checkout -b fix/issue-42

# Make changes, commit
git add . && git commit -m "fix: description"

# Push (CI runs on YOUR allowance, not ours)
git push origin fix/issue-42

# Create PR
gh pr create
```

Your PR will be:
- Analyzed by AI (Gemini, Groq) - your free tier
- Scanned for security issues - free
- Reviewed by CodeRabbit - free
- Verified by a different contributor

---

## The Economics

| Who | Pays For |
|-----|----------|
| Microsoft | GitHub Actions (2000 min/month per user) |
| Google | Gemini API (1500 req/day per user) |
| Groq | Llama 3 inference (14,400 req/day per user) |
| Contributors | Nothing ($0) |
| Host UK | Nothing ($0) |
| OSS Projects | Get free security fixes |

**100 contributors × free tiers = enterprise-scale compute for public good**

---

## Where the Work Goes

1. **Host UK packages** - Our tools and modules
2. **Unfunded OSS** - Popular packages with no security budget
3. **Community requests** - Projects our members depend on

We're not hoarding. We're redistributing tech resources to the commons.

---

## Questions?

- Discord: https://discord.gg/host-uk
- Issues: https://github.com/host-uk/core-devops/issues

**License:** EUPL-1.2 (copyleft, EU-recognized, compatible with GPL)

---

*Host UK CIC - Building ethical infrastructure for the open source community*
