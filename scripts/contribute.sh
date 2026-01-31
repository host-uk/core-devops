#!/bin/bash
# Host UK CIC - Contributor Setup
# One command to join the distributed compute network

set -e

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         Host UK CIC - Contributor Setup                      ║"
echo "║                                                              ║"
echo "║  Your free tier allowances will help fix unfunded OSS       ║"
echo "║  projects. Cost to you: \$0. Impact: Massive.                 ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Check if this is a fork
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [[ "$REMOTE_URL" == *"host-uk/core-devops"* ]]; then
    echo "⚠️  This is the upstream repo, not your fork."
    echo ""
    echo "Run this instead:"
    echo "  gh repo fork host-uk/core-devops --clone"
    echo "  cd core-devops"
    echo "  ./scripts/contribute.sh"
    exit 1
fi

echo "✓ Fork detected"
echo ""

# Check gh auth
if ! gh auth status &>/dev/null; then
    echo "⚠️  GitHub CLI not authenticated"
    echo "Run: gh auth login"
    exit 1
fi

echo "✓ GitHub CLI authenticated"
echo ""

# Setup secrets
echo "═══════════════════════════════════════════════════════════════"
echo " OPTIONAL: Add API keys for AI-powered analysis"
echo " (Skip any you don't want - security scans work without them)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

read -p "Add Gemini API key? (1500 req/day free) [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Get key at: https://aistudio.google.com/apikey"
    gh secret set GEMINI_API_KEY
fi

read -p "Add Groq API key? (14,400 req/day free) [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Get key at: https://console.groq.com/keys"
    gh secret set GROQ_API_KEY
fi

read -p "Add Mistral API key? (1M tokens/month free) [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Get key at: https://console.mistral.ai/"
    gh secret set MISTRAL_API_KEY
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo " ✅ SETUP COMPLETE"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Your fork is now part of the distributed compute network!"
echo ""
echo "What happens now:"
echo "  • Security scans run automatically (Semgrep, Trivy, Gitleaks)"
echo "  • AI analysis runs on your PRs (using your free tier)"
echo "  • You can verify others' work: core issues --label agent:review"
echo ""
echo "The compute you contribute helps fix security issues in"
echo "unfunded open source projects. Thank you! 🙏"
echo ""
echo "Questions? https://discord.gg/host-uk"
