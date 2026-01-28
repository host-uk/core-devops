# Install the Core CLI (Windows)
# Run: .\scripts\install-core.ps1

$ErrorActionPreference = "Stop"

$Repo = "Snider/Core"
$InstallDir = "$env:LOCALAPPDATA\Programs\core"

function Write-Info { Write-Host "[INFO] $args" -ForegroundColor Green }
function Write-Warn { Write-Host "[WARN] $args" -ForegroundColor Yellow }
function Write-Err { Write-Host "[ERROR] $args" -ForegroundColor Red; exit 1 }

function Test-Command($cmd) {
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

# Download pre-built binary
function Download-Binary {
    $arch = if ([Environment]::Is64BitOperatingSystem) { "amd64" } else { "386" }
    $url = "https://github.com/$Repo/releases/latest/download/core-windows-$arch.exe"

    Write-Info "Attempting to download pre-built binary..."
    Write-Info "URL: $url"

    try {
        New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
        Invoke-WebRequest -Uri $url -OutFile "$InstallDir\core.exe" -UseBasicParsing
        Write-Info "Downloaded to $InstallDir\core.exe"
        return $true
    } catch {
        Write-Warn "No pre-built binary available, will build from source"
        return $false
    }
}

# Build from source
function Build-FromSource {
    if (-not (Test-Command go)) {
        Write-Err "Go is required to build from source. Run '.\scripts\install-deps.ps1' first"
    }

    $tmpdir = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }

    Write-Info "Cloning $Repo..."
    git clone --depth 1 "https://github.com/$Repo.git" "$tmpdir\Core"

    Write-Info "Building core CLI..."
    Push-Location "$tmpdir\Core"
    go build -o core.exe ./cmd/core
    Pop-Location

    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    Move-Item "$tmpdir\Core\core.exe" "$InstallDir\core.exe" -Force

    Remove-Item -Recurse -Force $tmpdir
    Write-Info "Built and installed to $InstallDir\core.exe"
}

# Add to PATH
function Setup-Path {
    $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($userPath -notlike "*$InstallDir*") {
        Write-Info "Adding $InstallDir to PATH..."
        [Environment]::SetEnvironmentVariable("PATH", "$userPath;$InstallDir", "User")
        $env:PATH = "$env:PATH;$InstallDir"
    }
}

# Verify installation
function Verify {
    Setup-Path

    if (Test-Command core) {
        Write-Info "Verifying installation..."
        & core --help | Select-Object -First 5
        Write-Host ""
        Write-Info "core CLI installed successfully!"
    } elseif (Test-Path "$InstallDir\core.exe") {
        Write-Info "core CLI installed to $InstallDir\core.exe"
        Write-Info "Restart your terminal to use 'core' command"
    } else {
        Write-Err "Installation failed"
    }
}

# Main
function Main {
    Write-Info "Installing Core CLI..."

    # Try download first, fallback to build
    if (-not (Download-Binary)) {
        Build-FromSource
    }

    Verify
}

Main
