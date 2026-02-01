# TODO - Session Summary 2026-02-01

## ✅ Completed Today

### Issue Auto-Labeling
- [x] Issue templates (bug_report.yml, feature_request.yml) for core + core-devops
- [x] Auto-label workflow detects: type, project, priority, agentic keywords
- [x] Complexity dropdown in feature request template
- [x] Heuristic complexity detection (checklist count, code blocks, sections, file refs, keywords)
- [x] Retroactively labeled unlabeled issues in core repo
- [x] Test issue #70 created and auto-labeled correctly

### GitHub Org Setup
- [x] Dev branches as default (all repos)
- [x] Labels taxonomy (agent:*, priority:*, type:*, lang:*)
- [x] Discord webhooks (7 channels × 20 repos)
- [x] Branch protection rules
- [x] Org security defaults enabled

### CodeRabbit
- [x] Central config: host-uk/coderabbit
- [x] Per-repo .coderabbit.yaml (21 repos)
- [x] review_status: false

### CodeQL/Security
- [x] Enabled on all public repos
- [x] Language-appropriate scanning

### GitHub Projects
- [x] Auto-add workflow (label → project)
- [x] PROJECT_TOKEN secret set

### Agent Verification Workflow
- [x] Labels: agent:ready → agent:wip → agent:review → verified
- [x] Self-verification blocked
- [x] core/.github/workflows/agent-verify.yml

### Template Repo (core-devops)
- [x] Bootstrap workflow for new repos
- [x] TEMPLATE_SETUP.md guide

### Free Tier Integration
- [x] Gemini, Groq, Mistral, Cohere, Cloudflare workflows
- [x] Semgrep, Trivy, Gitleaks, OSV, Checkov
- [x] Jules dispatch workflow
- [x] CONTRIBUTING.md + scripts/contribute.sh

### Docs
- [x] VitePress setup
- [x] core docs sync tested
- [x] free-tier-services.md

### Container Images (core-images)
- [x] docker-compose.yml + devcontainer.json (packages/ mount)
- [x] Dual-registry workflow: GHCR + Docker Hub (lthn/*)
- [x] DOCKERHUB_USERNAME/TOKEN secrets (org-wide)
- [ ] Fix Dockerfile Python build (#2 - tiktoken, tree-sitter)
- [ ] Merge dev → main to publish images

### Core CLI Issues
- [x] #50 - linuxkit double-dash flags fix

## 🔲 Pending (Core CLI Issues Created)

- [ ] #46 - docs sync ignores packages_dir
- [ ] #47 - core qa command area
- [ ] #48 - core security command
- [ ] #49 - core monitor (aggregate free tier findings)

## 🔲 Next Steps

- [ ] Merge dev → main on repos to deploy docs
- [ ] Recruit first 10 contributors
- [ ] Rotate PROJECT_TOKEN (was shared in chat)
- [ ] Rotate DOCKERHUB_TOKEN (was shared in chat)
- [x] Add workflow to remaining PHP repos (8 repos)
- [ ] Set up external OSS project scanning
