# Install the Core CLI (Windows)
# Run: .\scripts\install-core.ps1

$ErrorActionPreference = "Stop"

$Repo = "host-uk/core"
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
    $url = "https://github.com/$Repo/releases/download/dev/core-windows-$arch.exe"

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
    if (-not (Test-Command git)) {
        Write-Err "Git is required to build from source. Run '.\scripts\install-deps.ps1' first"
    }
    if (-not (Test-Command go)) {
        Write-Err "Go is required to build from source. Run '.\scripts\install-deps.ps1' first"
    }

    $tmpdir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Force -Path $tmpdir | Out-Null

    try {
        Write-Info "Cloning $Repo..."
        $cloneDir = Join-Path $tmpdir "Core"
        git clone --depth 1 "https://github.com/$Repo.git" $cloneDir
        if ($LASTEXITCODE -ne 0) {
            Write-Err "Failed to clone repository"
        }

        Write-Info "Building core CLI..."
        Push-Location $cloneDir
        go build -o core.exe .
        if ($LASTEXITCODE -ne 0) {
            Pop-Location
            Write-Err "Go build failed"
        }
        Pop-Location

        New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
        Move-Item (Join-Path $cloneDir "core.exe") (Join-Path $InstallDir "core.exe") -Force

        Write-Info "Built and installed to $InstallDir\core.exe"
    } finally {
        if (Test-Path $tmpdir) {
            Remove-Item -Recurse -Force $tmpdir -ErrorAction SilentlyContinue
        }
    }
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
