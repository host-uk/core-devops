# Free Tier Services Integration

> **Host UK CIC** is a UK Community Interest Company. Our assets are legally locked for community benefit - we can't extract value for shareholders. This page documents how we aggregate free compute to benefit the open source commons.

## The Model

```
┌─────────────────────────────────────────────────────────────────┐
│                    100 CONTRIBUTORS                              │
│                                                                  │
│   Each contributes their FREE tier allowances:                   │
│   • GitHub Actions: 2000 min/month                               │
│   • Gemini: 1500 req/day                                         │
│   • Groq: 14,400 req/day                                         │
│   • Copilot: Free for OSS                                        │
│                                                                  │
│   Total daily capacity:                                          │
│   • 150,000 Gemini requests                                      │
│   • 1,440,000 Groq requests                                      │
│   • 6,666 GitHub Actions hours                                   │
│   • Unlimited security scans                                     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    core monitor                                  │
│                                                                  │
│   Aggregates findings → Creates tasks → Routes to agents         │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
┌─────────────────────────┐   ┌─────────────────────────────────┐
│   HOST UK PACKAGES      │   │   UNFUNDED OSS PROJECTS         │
│                         │   │                                 │
│   Our tools, modules    │   │   Popular packages with no      │
│                         │   │   security budget - we find     │
│                         │   │   and fix vulns, submit PRs     │
└─────────────────────────┘   └─────────────────────────────────┘
```

**The LLMs learned from open source. We're giving back.**

---

## AI/LLM APIs (Contributor Keys)

| Service | Free Tier | Speed | Best For |
|---------|-----------|-------|----------|
| **Groq** | 14,400 req/day | ⚡ Fastest | Quick triage, bulk analysis |
| **Gemini 2.0** | 1500 req/day | Fast | Code review, deep analysis |
| **Mistral** | 1M tokens/month | Fast | Code generation |
| **Cohere** | 1000 req/month | Medium | Classification, embeddings |
| **Cloudflare AI** | 10K neurons/day | Edge | Low latency |
| **Together.ai** | $5 credit | Fast | Multi-model |
| **Fireworks.ai** | 600 req/min | ⚡ Fast | High throughput |
| **Cerebras** | Free tier | ⚡⚡ Fastest | Bulk inference |

### Setup (2 minutes)

```bash
# In your fork
gh secret set GEMINI_API_KEY   # https://aistudio.google.com/apikey
gh secret set GROQ_API_KEY     # https://console.groq.com/keys
gh secret set MISTRAL_API_KEY  # https://console.mistral.ai/
```

---

## Security Scanners (No Keys Needed)

All free, unlimited, run automatically:

| Scanner | Finds | Output |
|---------|-------|--------|
| **Semgrep** | SAST vulns, code patterns | SARIF → GitHub Security |
| **Trivy** | Container vulns, IaC issues | SARIF → GitHub Security |
| **Gitleaks** | Leaked secrets, API keys | SARIF → GitHub Security |
| **OSV-Scanner** | Known CVEs (Google DB) | SARIF → GitHub Security |
| **Checkov** | IaC misconfigs | SARIF → GitHub Security |
| **CodeQL** | Deep semantic analysis | Native GitHub |
| **Dependabot** | Outdated deps | Native GitHub |

---

## Code Analysis Apps (Free for Public Repos)

Install these on your fork for extra coverage:

| App | Install | Provides |
|-----|---------|----------|
| **Snyk** | [Install](https://github.com/apps/snyk-io) | Deps + code vulns |
| **SonarCloud** | [Install](https://github.com/apps/sonarcloud) | Code quality |
| **CodeClimate** | [Install](https://github.com/apps/codeclimate) | Maintainability |
| **DeepSource** | [Install](https://github.com/apps/deepsource-io) | Autofix suggestions |
| **Codacy** | [Install](https://github.com/apps/codacy-production) | Multi-language |
| **Socket.dev** | [Install](https://github.com/apps/socket-security) | Supply chain |
| **GitGuardian** | [Install](https://github.com/apps/gitguardian) | Secret detection |
| **Aikido** | [Install](https://github.com/apps/aikido-security) | Full security suite |
| **Trunk.io** | [Install](https://github.com/apps/trunk-io) | Meta-linter (50+ tools) |

---

## AI Code Assistants (Free Tiers)

| Service | Free Access | Trigger |
|---------|-------------|---------|
| **Jules/Copilot** | OSS maintainers, students | `@jules fix this bug` |
| **Codeium** | Free forever | IDE extension |
| **Cody** | Free tier | IDE extension |
| **Amazon Q** | Free tier | IDE/CLI |
| **Continue.dev** | Free, open source | IDE extension |

---

## CI/CD Free Tiers

| Service | Free Allowance | Notes |
|---------|----------------|-------|
| **GitHub Actions** | 2000 min/month | Per user, public repos |
| **CircleCI** | 6000 min/month | Good for heavy builds |
| **GitLab CI** | 400 min/month | Alternative to GH |
| **Semaphore** | 1300 min/month | Fast builds |
| **Buildkite** | Free for OSS | Self-hosted option |

---

## Who Pays For All This?

| Provider | Why Free? |
|----------|-----------|
| **Microsoft** | GitHub market dominance, AI training data |
| **Google** | Gemini adoption, developer mindshare |
| **Groq** | Hardware showcase, market entry |
| **Others** | Developer ecosystem, future enterprise sales |

**They need OSS developers. We need compute. Fair trade.**

---

## Joining the Network

```bash
# Fork and setup (5 minutes)
gh repo fork host-uk/core-devops --clone
cd core-devops
./scripts/contribute.sh
```

Your unused free tier becomes part of a collective resource that:
1. Secures Host UK packages
2. Fixes vulnerabilities in unfunded OSS
3. Gives back to the projects that trained the AIs

**Cost: $0. Impact: Massive.**

---

*Host UK CIC - Ethical infrastructure for the open source commons*
