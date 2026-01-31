# Free Tier Services Integration

All these services provide free input that `core` CLI can monitor and feed into the Agentic system.

## AI/LLM APIs

| Service | Free Tier | Use Case |
|---------|-----------|----------|
| **Gemini 2.0** | 1500 req/day, 1M tokens/min | Code review, analysis |
| **Groq** | 14,400 req/day (Llama/Mixtral) | Fast inference, triage |
| **Mistral** | 1M tokens/month | Code generation |
| **Cohere** | 1000 req/month | Embeddings, classification |
| **Together.ai** | $5 free credit | Multi-model access |
| **Cloudflare AI** | 10,000 neurons/day | Edge inference |
| **Hugging Face** | Rate limited free | Open models |
| **Fireworks.ai** | 600 req/min free | Fast inference |
| **Cerebras** | Free tier | Ultra-fast inference |
| **SambaNova** | Free tier | Enterprise models |

## Code Analysis (All Free for Public Repos)

| Service | Provides | GitHub Integration |
|---------|----------|-------------------|
| **CodeQL** | Security vulnerabilities | Native |
| **Snyk** | Deps + code vulnerabilities | ✅ App |
| **SonarCloud** | Code quality + bugs | ✅ App |
| **Codacy** | Code quality + patterns | ✅ App |
| **DeepSource** | Code health + autofix | ✅ App |
| **CodeClimate** | Maintainability | ✅ App |
| **Semgrep** | SAST + custom rules | ✅ Action |
| **GitGuardian** | Secret detection | ✅ App |
| **Socket.dev** | Supply chain security | ✅ App |
| **Aikido Security** | Full security suite | ✅ App |
| **Qodana** | JetBrains code analysis | ✅ Action |
| **Trunk.io** | Meta-linter (50+ tools) | ✅ App |

## Dependency Management (Free)

| Service | Features |
|---------|----------|
| **Dependabot** | Auto-update PRs |
| **Renovate** | Smart dependency updates |
| **Socket.dev** | Malicious package detection |
| **Snyk** | Vulnerability database |
| **deps.dev** | Google's dep analysis |

## CI/CD Free Tiers

| Service | Free Allowance |
|---------|----------------|
| **GitHub Actions** | 2000 min/month |
| **CircleCI** | 6000 min/month |
| **GitLab CI** | 400 min/month |
| **Travis CI** | Unlimited for OSS |
| **Buildkite** | Free for OSS |
| **Semaphore** | 1300 min/month |
| **Buddy** | 5 projects free |

## Testing & Coverage (Free for OSS)

| Service | Features |
|---------|----------|
| **Codecov** | Coverage reports |
| **Coveralls** | Coverage tracking |
| **Percy** | Visual regression |
| **Chromatic** | Storybook visual tests |
| **BrowserStack** | Free for OSS |
| **LambdaTest** | Free tier |

## Error & Performance (Free Tiers)

| Service | Free Tier |
|---------|-----------|
| **Sentry** | 5K errors/month |
| **LogRocket** | 1K sessions/month |
| **Highlight.io** | 500 sessions/month |
| **Grafana Cloud** | 10K metrics |
| **Datadog** | 1 host free |

## AI Code Assistants (Free/OSS)

| Service | Access |
|---------|--------|
| **GitHub Copilot** | Free for OSS maintainers |
| **Jules** | Free with Copilot |
| **Amazon Q** | Free tier |
| **Codeium** | Free forever |
| **Tabnine** | Free tier |
| **Cursor** | Free tier |
| **Cody (Sourcegraph)** | Free tier |
| **Continue.dev** | Free, open source |

## Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    FREE TIER SERVICES                        │
│                                                              │
│  Snyk ─────┐                                                │
│  SonarCloud─┤                                                │
│  CodeQL ────┼──→ GitHub Checks API ──→ ┌──────────────────┐ │
│  Semgrep ───┤                          │                  │ │
│  DeepSource─┘                          │   core monitor   │ │
│                                        │                  │ │
│  Gemini ────┐                          │  Watches for:    │ │
│  Groq ──────┼──→ PR Comments ─────────→│  - Check failures│ │
│  Mistral ───┘                          │  - Vulnerabilities│
│                                        │  - Code smells   │ │
│  Dependabot─┐                          │  - PR reviews    │ │
│  Renovate ──┼──→ PRs/Issues ──────────→│  - New deps      │ │
│  Socket.dev─┘                          │                  │ │
└────────────────────────────────────────┴────────┬─────────┘
                                                   │
                                                   ▼
                                    ┌──────────────────────────┐
                                    │   core CLI               │
                                    │                          │
                                    │   Aggregates + filters   │
                                    │   Creates actionable     │
                                    │   tasks                  │
                                    └────────────┬─────────────┘
                                                 │
                                                 ▼
                                    ┌──────────────────────────┐
                                    │   Host UK Agentic API    │
                                    │                          │
                                    │   - Task queue           │
                                    │   - Agent assignment     │
                                    │   - Verification flow    │
                                    └──────────────────────────┘
```
