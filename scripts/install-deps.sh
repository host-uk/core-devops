#!/usr/bin/env bash
set -e

# Install system dependencies for Host UK development
# Supports: macOS (brew), Linux (apt/dnf), Windows (choco via WSL)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *) echo "unknown" ;;
    esac
}

# Check if command exists
has() {
    command -v "$1" &> /dev/null
}

# Install Homebrew (macOS/Linux)
install_brew() {
    if has brew; then
        info "Homebrew already installed"
        return
    fi

    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add to PATH for this session
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
}

# Install packages via brew
brew_install() {
    local pkg=$1
    if has "$pkg"; then
        info "$pkg already installed"
    else
        info "Installing $pkg..."
        brew install "$pkg"
    fi
}

# Install packages via apt
apt_install() {
    local pkg=$1
    if has "$pkg"; then
        info "$pkg already installed"
    else
        info "Installing $pkg..."
        sudo apt-get update -qq
        sudo apt-get install -y "$pkg"
    fi
}

# macOS setup
setup_macos() {
    info "Setting up macOS environment..."

    install_brew

    brew_install git
    brew_install gh
    brew_install go
    brew_install php
    brew_install composer
    brew_install node
    brew_install pnpm

    # Optional
    if ! has docker; then
        warn "Docker not installed. Install Docker Desktop manually if needed."
    fi
}

# Linux setup
setup_linux() {
    info "Setting up Linux environment..."

    # Detect package manager
    if has apt-get; then
        setup_linux_apt
    elif has dnf; then
        setup_linux_dnf
    elif has brew; then
        setup_linux_brew
    else
        warn "Unknown package manager. Installing Homebrew..."
        install_brew
        setup_linux_brew
    fi
}

setup_linux_apt() {
    apt_install git
    apt_install gh || warn "GitHub CLI may need manual install: https://cli.github.com"

    # Go
    if ! has go; then
        info "Installing Go..."
        sudo apt-get install -y golang-go || {
            # Fallback to manual install for newer version
            curl -LO https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
            sudo rm -rf /usr/local/go
            sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
            rm go1.22.0.linux-amd64.tar.gz
            export PATH=$PATH:/usr/local/go/bin
        }
    fi

    # PHP
    apt_install php

    # Composer
    if ! has composer; then
        info "Installing Composer..."
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
    fi

    # Node
    if ! has node; then
        info "Installing Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi

    # pnpm
    if ! has pnpm; then
        info "Installing pnpm..."
        npm install -g pnpm
    fi
}

setup_linux_dnf() {
    sudo dnf install -y git gh golang php composer nodejs
    npm install -g pnpm
}

setup_linux_brew() {
    install_brew
    brew_install git
    brew_install gh
    brew_install go
    brew_install php
    brew_install composer
    brew_install node
    brew_install pnpm
}

# Windows setup (via chocolatey in PowerShell or WSL)
setup_windows() {
    warn "Windows detected. Please run scripts/install-deps.ps1 in PowerShell"
    warn "Or use WSL with: wsl ./scripts/install-deps.sh"
    exit 1
}

# Main
main() {
    local os=$(detect_os)
    info "Detected OS: $os"

    case "$os" in
        macos)   setup_macos ;;
        linux)   setup_linux ;;
        windows) setup_windows ;;
        *)       error "Unsupported OS: $os" ;;
    esac

    info "Dependencies installed!"
    echo ""
    echo "Next: Run './scripts/install-core.sh' to install the core CLI"
}

main "$@"
