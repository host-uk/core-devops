#!/usr/bin/env bash
set -e

# Install the Core CLI
# Either downloads a pre-built binary or builds from source

REPO="Snider/Core"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
BUILD_FROM_SOURCE="${BUILD_FROM_SOURCE:-auto}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

has() {
    command -v "$1" &> /dev/null
}

detect_arch() {
    case "$(uname -m)" in
        x86_64|amd64) echo "amd64" ;;
        arm64|aarch64) echo "arm64" ;;
        *) echo "unknown" ;;
    esac
}

detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "darwin" ;;
        Linux*)  echo "linux" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *) echo "unknown" ;;
    esac
}

# Try to download pre-built binary
download_binary() {
    local os=$(detect_os)
    local arch=$(detect_arch)
    local url="https://github.com/$REPO/releases/latest/download/core-${os}-${arch}"

    if [[ "$os" == "windows" ]]; then
        url="${url}.exe"
    fi

    info "Attempting to download pre-built binary..."
    info "URL: $url"

    if curl -fsSL -o /tmp/core "$url" 2>/dev/null; then
        chmod +x /tmp/core
        mkdir -p "$INSTALL_DIR"
        mv /tmp/core "$INSTALL_DIR/core"
        info "Downloaded to $INSTALL_DIR/core"
        return 0
    else
        warn "No pre-built binary available, will build from source"
        return 1
    fi
}

# Build from source
build_from_source() {
    if ! has go; then
        error "Go is required to build from source. Run './scripts/install-deps.sh' first"
    fi

    local tmpdir=$(mktemp -d)
    info "Cloning $REPO..."
    git clone --depth 1 "https://github.com/$REPO.git" "$tmpdir/Core"

    info "Building core CLI..."
    cd "$tmpdir/Core"
    go build -o core ./cmd/core

    mkdir -p "$INSTALL_DIR"
    mv core "$INSTALL_DIR/core"

    rm -rf "$tmpdir"
    info "Built and installed to $INSTALL_DIR/core"
}

# Add to PATH if needed
setup_path() {
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        warn "$INSTALL_DIR is not in your PATH"
        echo ""
        echo "Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
        echo ""
        echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
        echo ""

        # Try to add to current session
        export PATH="$PATH:$INSTALL_DIR"
    fi
}

# Verify installation
verify() {
    if has core; then
        info "Verifying installation..."
        core --help | head -5
        echo ""
        info "core CLI installed successfully!"
    else
        setup_path
        if [[ -f "$INSTALL_DIR/core" ]]; then
            info "core CLI installed to $INSTALL_DIR/core"
            info "Restart your shell or run: export PATH=\"\$PATH:$INSTALL_DIR\""
        else
            error "Installation failed"
        fi
    fi
}

main() {
    info "Installing Core CLI..."

    mkdir -p "$INSTALL_DIR"

    # Try download first, fallback to build
    if [[ "$BUILD_FROM_SOURCE" == "true" ]]; then
        build_from_source
    elif [[ "$BUILD_FROM_SOURCE" == "false" ]]; then
        download_binary || error "Download failed and BUILD_FROM_SOURCE=false"
    else
        # auto: try download, fallback to build
        download_binary || build_from_source
    fi

    setup_path
    verify
}

main "$@"
