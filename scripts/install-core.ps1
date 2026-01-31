# Install the Core CLI (Windows)
# Run: .\scripts\install-core.ps1

$ErrorActionPreference = "Stop"

$Repo = "host-uk/core"
$Version = "v0.1.0"  # Pinned version - update when releasing new versions

function Write-Info { Write-Host "[INFO] $args" -ForegroundColor Green }
function Write-Warn { Write-Host "[WARN] $args" -ForegroundColor Yellow }
function Write-Err { Write-Host "[ERROR] $args" -ForegroundColor Red; exit 1 }

function Test-Command($cmd) {
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

# Validate and get secure install directory
function Get-SecureInstallDir {
    # Validate LOCALAPPDATA is within user profile
    $localAppData = $env:LOCALAPPDATA
    $userProfile = $env:USERPROFILE

    if ([string]::IsNullOrEmpty($localAppData)) {
        Write-Err "LOCALAPPDATA environment variable is not set"
    }

    if ([string]::IsNullOrEmpty($userProfile)) {
        Write-Err "USERPROFILE environment variable is not set"
    }

    # Resolve to absolute paths
    $resolvedLocalAppData = [System.IO.Path]::GetFullPath($localAppData)
    $resolvedUserProfile = [System.IO.Path]::GetFullPath($userProfile)

    # Ensure LOCALAPPDATA is under user profile (prevent redirection attacks)
    if (-not $resolvedLocalAppData.StartsWith($resolvedUserProfile, [System.StringComparison]::OrdinalIgnoreCase)) {
        Write-Err "LOCALAPPDATA ($resolvedLocalAppData) is not within user profile ($resolvedUserProfile). Possible path manipulation detected."
    }

    $installDir = Join-Path $resolvedLocalAppData "Programs\core"

    # Validate the resolved path doesn't contain suspicious patterns
    if ($installDir -match '\.\.' -or $installDir -match '[\x00-\x1f]') {
        Write-Err "Invalid characters detected in install path"
    }

    return $installDir
}

$InstallDir = Get-SecureInstallDir

# Verify SHA256 hash of downloaded file
function Test-FileHash {
    param(
        [string]$FilePath,
        [string]$ExpectedHash
    )

    $actualHash = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash
    if ($actualHash -ne $ExpectedHash) {
        Remove-Item -Path $FilePath -Force -ErrorAction SilentlyContinue
        Write-Err "Hash verification failed! Expected: $ExpectedHash, Got: $actualHash. The downloaded file may be corrupted or tampered with."
    }
    Write-Info "Hash verification passed"
}

# Download pre-built binary with integrity verification
function Download-Binary {
    $arch = if ([Environment]::Is64BitOperatingSystem) { "amd64" } else { "386" }
    $binaryUrl = "https://github.com/$Repo/releases/download/$Version/core-windows-$arch.exe"
    $checksumUrl = "https://github.com/$Repo/releases/download/$Version/checksums.txt"

    Write-Info "Attempting to download pre-built binary (version $Version)..."
    Write-Info "URL: $binaryUrl"

    try {
        New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

        # Verify install directory is actually a directory (not a symlink to elsewhere)
        $dirInfo = Get-Item $InstallDir
        if ($dirInfo.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Write-Err "Install directory is a symbolic link. Possible symlink attack detected."
        }

        $tempExe = Join-Path $InstallDir "core.exe.tmp"

        # Download the binary
        Invoke-WebRequest -Uri $binaryUrl -OutFile $tempExe -UseBasicParsing

        # Download and parse checksums
        Write-Info "Verifying download integrity..."
        $checksumContent = Invoke-WebRequest -Uri $checksumUrl -UseBasicParsing | Select-Object -ExpandProperty Content

        # Parse checksum file (format: "hash  filename")
        $expectedHash = $null
        $checksumLines = $checksumContent -split "`n"
        foreach ($line in $checksumLines) {
            if ($line -match "^([a-fA-F0-9]{64})\s+.*core-windows-$arch\.exe") {
                $expectedHash = $matches[1].ToUpper()
                break
            }
        }

        if ([string]::IsNullOrEmpty($expectedHash)) {
            Remove-Item -Path $tempExe -Force -ErrorAction SilentlyContinue
            Write-Err "Could not find checksum for core-windows-$arch.exe in checksums.txt"
        }

        # Verify hash
        Test-FileHash -FilePath $tempExe -ExpectedHash $expectedHash

        # Move to final location only after verification
        Move-Item -Path $tempExe -Destination (Join-Path $InstallDir "core.exe") -Force

        Write-Info "Downloaded and verified: $InstallDir\core.exe"
        return $true
    } catch [System.Net.WebException] {
        Write-Warn "Network error during download: $($_.Exception.Message)"
        Write-Warn "Will attempt to build from source"
        return $false
    } catch [System.IO.IOException] {
        Write-Warn "File system error: $($_.Exception.Message)"
        Write-Warn "Will attempt to build from source"
        return $false
    } catch {
        Write-Warn "Download failed: $($_.Exception.Message)"
        Write-Warn "Will attempt to build from source"
        return $false
    }
}

# Set restrictive ACL on directory (owner-only access)
function Set-SecureDirectoryAcl {
    param([string]$Path)

    try {
        $acl = Get-Acl $Path

        # Disable inheritance and remove inherited rules
        $acl.SetAccessRuleProtection($true, $false)

        # Clear existing rules
        $acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) } | Out-Null

        # Add full control for current user only
        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $currentUser,
            [System.Security.AccessControl.FileSystemRights]::FullControl,
            [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit,
            [System.Security.AccessControl.PropagationFlags]::None,
            [System.Security.AccessControl.AccessControlType]::Allow
        )
        $acl.AddAccessRule($rule)

        Set-Acl -Path $Path -AclObject $acl
        Write-Info "Set restrictive permissions on $Path"
    } catch {
        Write-Warn "Could not set restrictive ACL: $($_.Exception.Message)"
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

    # Set restrictive ACL on temp directory
    Set-SecureDirectoryAcl -Path $tmpdir

    try {
        Write-Info "Cloning $Repo (version $Version)..."
        $cloneDir = Join-Path $tmpdir "Core"

        # Clone specific tag for reproducibility
        git clone --depth 1 --branch $Version "https://github.com/$Repo.git" $cloneDir
        if ($LASTEXITCODE -ne 0) {
            Write-Err "Failed to clone repository at version $Version"
        }

        Write-Info "Building core CLI..."
        Push-Location $cloneDir
        try {
            go build -o core.exe .
            if ($LASTEXITCODE -ne 0) {
                Write-Err "Go build failed"
            }
        } finally {
            Pop-Location
        }

        New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

        # Verify install directory is not a symlink
        $dirInfo = Get-Item $InstallDir
        if ($dirInfo.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Write-Err "Install directory is a symbolic link. Possible symlink attack detected."
        }

        Move-Item (Join-Path $cloneDir "core.exe") (Join-Path $InstallDir "core.exe") -Force

        Write-Info "Built and installed to $InstallDir\core.exe"
    } finally {
        if (Test-Path $tmpdir) {
            Remove-Item -Recurse -Force $tmpdir -ErrorAction SilentlyContinue
        }
    }
}

# Validate and add to PATH
function Setup-Path {
    $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")

    # Validate InstallDir is a real directory under user profile
    if (-not (Test-Path $InstallDir -PathType Container)) {
        Write-Warn "Install directory does not exist, skipping PATH setup"
        return
    }

    $resolvedInstallDir = [System.IO.Path]::GetFullPath($InstallDir)
    $resolvedUserProfile = [System.IO.Path]::GetFullPath($env:USERPROFILE)

    # Ensure we're only adding paths under user profile
    if (-not $resolvedInstallDir.StartsWith($resolvedUserProfile, [System.StringComparison]::OrdinalIgnoreCase)) {
        Write-Warn "Install directory is outside user profile, skipping PATH modification for security"
        return
    }

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
    Write-Info "Installing Core CLI (version $Version)..."

    # Try download first, fallback to build
    if (-not (Download-Binary)) {
        Build-FromSource
    }

    Verify
}

Main
