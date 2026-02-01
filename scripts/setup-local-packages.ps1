# Setup local package linking for PHP dependency testing
# Usage: .\scripts\setup-local-packages.ps1 [package-name]
# Example: .\scripts\setup-local-packages.ps1 core-tenant

param(
    [string]$PackageName
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir
$PackagesDir = Join-Path $RootDir "packages"

function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Step { param($msg) Write-Host "[STEP] $msg" -ForegroundColor Cyan }

# Path repositories to inject
$PathRepositories = @(
    @{type = "path"; url = "../core-php"; options = @{symlink = $true}}
    @{type = "path"; url = "../core-tenant"; options = @{symlink = $true}}
    @{type = "path"; url = "../core-admin"; options = @{symlink = $true}}
    @{type = "path"; url = "../core-api"; options = @{symlink = $true}}
    @{type = "path"; url = "../core-mcp"; options = @{symlink = $true}}
    @{type = "path"; url = "../core-agentic"; options = @{symlink = $true}}
    @{type = "path"; url = "../core-commerce"; options = @{symlink = $true}}
    @{type = "path"; url = "../core-content"; options = @{symlink = $true}}
    @{type = "path"; url = "../core-tools"; options = @{symlink = $true}}
)

function Setup-Package {
    param([string]$pkg)

    $pkgDir = Join-Path $PackagesDir $pkg
    $composerJson = Join-Path $pkgDir "composer.json"
    $target = Join-Path $pkgDir "composer.local.json"

    if (-not (Test-Path $pkgDir)) {
        Write-Warn "Package directory not found: $pkgDir"
        return
    }

    if (-not (Test-Path $composerJson)) {
        Write-Warn "No composer.json found in $pkg (skipping)"
        return
    }

    if (Test-Path $target) {
        Write-Warn "composer.local.json already exists in $pkg (skipping)"
        return
    }

    Write-Step "Setting up $pkg..."

    # Read original composer.json
    $original = Get-Content $composerJson -Raw | ConvertFrom-Json

    # Add repositories array (path repos must come first)
    $original | Add-Member -NotePropertyName "repositories" -NotePropertyValue $PathRepositories -Force

    # Write merged composer.local.json (UTF-8 without BOM for Composer compatibility)
    $json = $original | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText($target, $json, [System.Text.UTF8Encoding]::new($false))

    # Add to .gitignore if not already there
    $gitignore = Join-Path $pkgDir ".gitignore"
    if (Test-Path $gitignore) {
        $content = Get-Content $gitignore -Raw
        if ($content -notmatch "composer\.local\.json") {
            Add-Content $gitignore "composer.local.json"
        }
    } else {
        "composer.local.json" | Out-File $gitignore -Encoding utf8
    }

    Write-Info "Created $target"
}

# Main
if ($PackageName) {
    # Setup specific package
    Setup-Package $PackageName
} else {
    # Setup all packages that depend on host-uk/core
    Write-Info "Setting up local package linking for all packages..."

    $packages = Get-ChildItem -Path $PackagesDir -Directory

    foreach ($dir in $packages) {
        $pkg = $dir.Name

        # Skip packages that don't need it
        if ($pkg -eq "core-php" -or $pkg -eq "core-template") {
            continue
        }

        # Check if composer.json exists and has host-uk dependencies
        $composerJson = Join-Path $dir.FullName "composer.json"
        if (Test-Path $composerJson) {
            $content = Get-Content $composerJson -Raw
            if ($content -match '"host-uk/') {
                Setup-Package $pkg
            }
        }
    }
}

Write-Host ""
Write-Info "Done! To install dependencies with local packages:"
Write-Host ""
Write-Host "  cd packages\<package>"
Write-Host "  `$env:COMPOSER='composer.local.json'; composer install"
Write-Host ""
Write-Host "Or on a single line:"
Write-Host ""
Write-Host "  powershell -Command `"`$env:COMPOSER='composer.local.json'; composer install`""
Write-Host ""
