# Free Tier Compute Guide

This project uses distributed compute from contributors' free tier allowances. Here's how to maximize it.

## GitHub Actions (Microsoft)

**Free tier:** 2,000 minutes/month for public repos

When you fork this repo, CI runs on YOUR allowance, not upstream's. This includes:
- Full test suite
- Linting and formatting
- Security scanning
- AI-powered triage

## Gemini API (Google)

**Free tier:** 1,500 requests/day, 1M tokens/minute

### Setup

1. Get API key: https://aistudio.google.com/apikey
2. Add to your fork's secrets:
   ```bash
   gh secret set GEMINI_API_KEY --repo YOUR_USER/YOUR_FORK
   ```

The `ai-worker.yml` workflow will use your Gemini allowance for:
- Code review
- Bug detection
- Security analysis

## Jules / Copilot (GitHub)

**Free tier:** Available with GitHub Copilot (free for OSS contributors)

### Trigger Jules

Comment on any issue:
```
@jules fix the authentication bug in login.php
@jules add unit tests for the User model
@jules refactor to use async/await
```

Jules will:
1. Analyze the issue
2. Write code to fix it
3. Create a PR on your fork
4. Uses YOUR Copilot allowance

### Get Copilot Free

- Open source contributors: https://github.com/settings/copilot
- Students: GitHub Education pack
- Verified OSS maintainers: Free Copilot Pro

## CodeRabbit

**Free tier:** Unlimited for public repos

Already configured via `.coderabbit.yaml`. Reviews run automatically on PRs.

## Compute Distribution Model

```
┌────────────────────────────────────────────┐
│           CONTRIBUTOR FORK                  │
│                                            │
│  ┌─────────────┐  ┌─────────────┐          │
│  │   GitHub    │  │   Gemini    │          │
│  │   Actions   │  │   2.0 Flash │          │
│  │   FREE      │  │   FREE      │          │
│  └─────────────┘  └─────────────┘          │
│                                            │
│  ┌─────────────┐  ┌─────────────┐          │
│  │   Jules/    │  │  CodeRabbit │          │
│  │   Copilot   │  │   FREE      │          │
│  │   FREE*     │  │             │          │
│  └─────────────┘  └─────────────┘          │
│                                            │
│  * With Copilot Pro (free for OSS)        │
└────────────────────────────────────────────┘
                    │
                    │ PR (already analyzed)
                    ▼
┌────────────────────────────────────────────┐
│           UPSTREAM REPO                     │
│                                            │
│  Just verify fork CI passed ✓              │
│  Cost: ~$0.001 per PR                      │
└────────────────────────────────────────────┘
```

## For Donor Fleet Members

If you want to contribute compute without coding:

1. Fork the repo
2. Set up your API keys (Gemini, etc.)
3. Keep Actions enabled
4. Pick up `agent:review` tasks to verify others' work

Your free tier becomes part of the distributed compute network!
