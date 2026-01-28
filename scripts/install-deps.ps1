# Install system dependencies for Host UK development (Windows)
# Run: .\scripts\install-deps.ps1

$ErrorActionPreference = "Stop"

function Write-Info { Write-Host "[INFO] $args" -ForegroundColor Green }
function Write-Warn { Write-Host "[WARN] $args" -ForegroundColor Yellow }
function Write-Err { Write-Host "[ERROR] $args" -ForegroundColor Red; exit 1 }

function Test-Command($cmd) {
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

# Install Chocolatey if not present
function Install-Chocolatey {
    if (Test-Command choco) {
        Write-Info "Chocolatey already installed"
        return
    }

    Write-Info "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # Refresh PATH
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
}

# Install a package via Chocolatey
function Install-ChocoPackage($pkg, $cmd = $pkg) {
    if (Test-Command $cmd) {
        Write-Info "$pkg already installed"
    } else {
        Write-Info "Installing $pkg..."
        choco install $pkg -y
        # Refresh PATH
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
    }
}

# Main setup
function Main {
    Write-Info "Setting up Windows development environment..."

    # Check if running as admin
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Err "Please run this script as Administrator"
    }

    Install-Chocolatey

    # Core tools
    Install-ChocoPackage "git"
    Install-ChocoPackage "gh"
    Install-ChocoPackage "golang" "go"

    # PHP development
    Install-ChocoPackage "php"
    Install-ChocoPackage "composer"

    # Node development
    Install-ChocoPackage "nodejs" "node"

    # pnpm via npm
    if (-not (Test-Command pnpm)) {
        Write-Info "Installing pnpm..."
        npm install -g pnpm
    }

    # Optional: Docker Desktop
    if (-not (Test-Command docker)) {
        Write-Warn "Docker not installed. Install Docker Desktop manually if needed."
    }

    Write-Info "Dependencies installed!"
    Write-Host ""
    Write-Host "Next: Run '.\scripts\install-core.ps1' to install the core CLI"
}

Main
