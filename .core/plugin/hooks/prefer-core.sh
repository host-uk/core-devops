#!/bin/bash
# prefer-core.sh - Suggest core CLI commands over raw commands
#
# This hook is called before certain commands to suggest core CLI equivalents.
# It's informational only and doesn't block the original command.

set -euo pipefail

COMMAND="${1:-}"

suggest() {
    echo ""
    echo "💡 Tip: Consider using the core CLI instead:"
    echo "   $1"
    echo ""
}

case "$COMMAND" in
    "git add"*)
        suggest "core commit (stages and commits with Claude-assisted messages)"
        ;;
    "git commit"*)
        suggest "core commit (Claude-assisted commit messages)"
        ;;
    "git push"*)
        suggest "core push (pushes all repos with unpushed commits)"
        ;;
    "git pull"*)
        suggest "core pull (pulls all repos that are behind)"
        ;;
    "composer test"*)
        suggest "core php test (runs from workspace root, targets active package)"
        ;;
    "composer lint"*)
        suggest "core php lint (runs from workspace root, targets active package)"
        ;;
    *)
        # No suggestion for this command
        ;;
esac

# Always exit 0 - this is informational, not blocking
exit 0
