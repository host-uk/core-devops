# Clone all Host UK repos (Windows alternative to `core setup`)
# Run: .\scripts\clone-repos.ps1

$ErrorActionPreference = "Stop"

$repos = @(
    "core-php",
    "core-tenant",
    "core-admin",
    "core-api",
    "core-mcp",
    "core-agentic",
    "core-bio",
    "core-social",
    "core-analytics",
    "core-notify",
    "core-trust",
    "core-support",
    "core-commerce",
    "core-content",
    "core-tools",
    "core-uptelligence",
    "core-developer",
    "core-template"
)

$packagesDir = Join-Path $PSScriptRoot "..\packages"

Write-Host "[INFO] Cloning repos to $packagesDir" -ForegroundColor Green

foreach ($repo in $repos) {
    $repoPath = Join-Path $packagesDir $repo

    if (Test-Path $repoPath) {
        Write-Host "[SKIP] $repo already exists" -ForegroundColor Yellow
        continue
    }

    Write-Host "[CLONE] $repo..." -ForegroundColor Cyan
    gh repo clone "host-uk/$repo" $repoPath

    if ($LASTEXITCODE -ne 0) {
        Write-Host "[WARN] Failed to clone $repo" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "[DONE] Repos cloned. Run 'composer install' in each package." -ForegroundColor Green
