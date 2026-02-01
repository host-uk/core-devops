#!/usr/bin/env bash
# Setup local package linking for PHP dependency testing
# Usage: ./scripts/setup-local-packages.sh [package-name]
# Example: ./scripts/setup-local-packages.sh core-tenant

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PACKAGES_DIR="$ROOT_DIR/packages"

# Colour output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No colour

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
step() { echo -e "${CYAN}[STEP]${NC} $1"; }

# Path repositories JSON to inject
REPOSITORIES='[
    {"type": "path", "url": "../core-php", "options": {"symlink": true}},
    {"type": "path", "url": "../core-tenant", "options": {"symlink": true}},
    {"type": "path", "url": "../core-admin", "options": {"symlink": true}},
    {"type": "path", "url": "../core-api", "options": {"symlink": true}},
    {"type": "path", "url": "../core-mcp", "options": {"symlink": true}},
    {"type": "path", "url": "../core-agentic", "options": {"symlink": true}},
    {"type": "path", "url": "../core-commerce", "options": {"symlink": true}},
    {"type": "path", "url": "../core-content", "options": {"symlink": true}},
    {"type": "path", "url": "../core-tools", "options": {"symlink": true}}
]'

# Check for jq (required for JSON manipulation)
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Install it with: brew install jq"
    exit 1
fi

# Setup function for a single package
setup_package() {
    local pkg="$1"
    local pkg_dir="$PACKAGES_DIR/$pkg"
    local composer_json="$pkg_dir/composer.json"
    local target="$pkg_dir/composer.local.json"

    if [[ ! -d "$pkg_dir" ]]; then
        warn "Package directory not found: $pkg_dir"
        return 1
    fi

    if [[ ! -f "$composer_json" ]]; then
        warn "No composer.json found in $pkg (skipping)"
        return 0
    fi

    if [[ -f "$target" ]]; then
        warn "composer.local.json already exists in $pkg (skipping)"
        return 0
    fi

    step "Setting up $pkg..."

    # Merge repositories into composer.json and write to composer.local.json
    jq --argjson repos "$REPOSITORIES" '. + {repositories: $repos}' "$composer_json" > "$target"

    # Add to .gitignore if not already there
    local gitignore="$pkg_dir/.gitignore"
    if [[ -f "$gitignore" ]]; then
        if ! grep -q "composer.local.json" "$gitignore"; then
            echo "composer.local.json" >> "$gitignore"
        fi
    else
        echo "composer.local.json" > "$gitignore"
    fi

    info "Created $target"
}

# Main
if [[ -n "$1" ]]; then
    # Setup specific package
    setup_package "$1"
else
    # Setup all packages that depend on host-uk/core
    info "Setting up local package linking for all packages..."

    for dir in "$PACKAGES_DIR"/*/; do
        pkg="$(basename "$dir")"

        # Skip packages that don't need it (core-php has no deps, core-template is a project)
        if [[ "$pkg" == "core-php" || "$pkg" == "core-template" ]]; then
            continue
        fi

        # Check if composer.json exists and has host-uk dependencies
        if [[ -f "$dir/composer.json" ]]; then
            if grep -q '"host-uk/' "$dir/composer.json"; then
                setup_package "$pkg"
            fi
        fi
    done
fi

echo ""
info "Done! To install dependencies with local packages:"
echo ""
echo "  cd packages/<package>"
echo "  COMPOSER=composer.local.json composer install"
echo ""
echo "Or use the dev:packages script if available:"
echo ""
echo "  composer dev:packages"
echo ""
