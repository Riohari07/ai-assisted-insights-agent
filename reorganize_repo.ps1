# PowerShell version of reorganize script
# Run from repo root: .\reorganize_repo.ps1

Write-Host "🔄 Reorganizing repository structure..." -ForegroundColor Cyan

# Create new numbered directories
$folders = @(
    "01_docs",
    "02_examples/claude-desktop",
    "02_examples/jupyter", 
    "02_examples/python-client",
    "02_examples/streaming-demo",
    "02_examples/ecommerce-demo",
    "02_examples/financial-demo",
    "02_examples/hr-demo",
    "03_data",
    "04_scripts",
    "05_tests",
    "06_configs"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

# -----------------------------------------------------------------------------
# Move docs/
# -----------------------------------------------------------------------------
Write-Host "📁 Moving docs/ → 01_docs/" -ForegroundColor Yellow
Get-ChildItem docs/*.md | ForEach-Object { git mv $_.FullName 01_docs/ }

# -----------------------------------------------------------------------------
# Move examples/
# -----------------------------------------------------------------------------
Write-Host "📁 Moving examples/ → 02_examples/" -ForegroundColor Yellow
if (Test-Path examples/README.md) { git mv examples/README.md 02_examples/ }
if (Test-Path examples/USAGE.md) { git mv examples/USAGE.md 02_examples/ }
if (Test-Path examples/DEMOS.md) { git mv examples/DEMOS.md 02_examples/ }
if (Test-Path examples/query_metrics.py) { git mv examples/query_metrics.py 02_examples/ }

# Subdirectories
$subDirs = @("claude-desktop", "jupyter", "python-client", "streaming-demo", "ecommerce-demo", "financial-demo", "hr-demo")
foreach ($dir in $subDirs) {
    if (Test-Path "examples/$dir") {
        Get-ChildItem "examples/$dir/*" -ErrorAction SilentlyContinue | ForEach-Object { 
            git mv $_.FullName "02_examples/$dir/" 
        }
    }
}

# -----------------------------------------------------------------------------
# Move data/
# -----------------------------------------------------------------------------
Write-Host "📁 Moving data/ → 03_data/" -ForegroundColor Yellow
Get-ChildItem data/* -ErrorAction SilentlyContinue | ForEach-Object { git mv $_.FullName 03_data/ }

# -----------------------------------------------------------------------------
# Move scripts/
# -----------------------------------------------------------------------------
Write-Host "📁 Moving scripts/ → 04_scripts/" -ForegroundColor Yellow
if (Test-Path scripts) {
    Get-ChildItem scripts/* -ErrorAction SilentlyContinue | ForEach-Object { git mv $_.FullName 04_scripts/ }
}

# -----------------------------------------------------------------------------
# Move tests/
# -----------------------------------------------------------------------------
Write-Host "📁 Moving tests/ → 05_tests/" -ForegroundColor Yellow
Get-ChildItem tests/* -ErrorAction SilentlyContinue | ForEach-Object { git mv $_.FullName 05_tests/ }

# -----------------------------------------------------------------------------
# Consolidate configs/
# -----------------------------------------------------------------------------
Write-Host "📁 Moving config files → 06_configs/" -ForegroundColor Yellow
Get-ChildItem config*.yaml -ErrorAction SilentlyContinue | ForEach-Object { git mv $_.FullName 06_configs/ }

# -----------------------------------------------------------------------------
# Clean up empty directories
# -----------------------------------------------------------------------------
Write-Host "🧹 Cleaning up empty directories..." -ForegroundColor Yellow
@("docs", "examples", "data", "scripts", "tests") | ForEach-Object {
    if (Test-Path $_ -PathType Container) {
        $items = Get-ChildItem $_ -Recurse -ErrorAction SilentlyContinue
        if (-not $items) {
            Remove-Item $_ -Force -ErrorAction SilentlyContinue
        }
    }
}

# -----------------------------------------------------------------------------
# Commit
# -----------------------------------------------------------------------------
Write-Host "✅ Committing changes..." -ForegroundColor Green
git add -A
git commit -m "refactor: reorganize repo with numbered folders for clarity

- docs/ → 01_docs/
- examples/ → 02_examples/
- data/ → 03_data/
- scripts/ → 04_scripts/
- tests/ → 05_tests/
- config*.yaml → 06_configs/
- insights_agent/ unchanged (Python package)
"

Write-Host ""
Write-Host "✅ Done! New structure:" -ForegroundColor Green
Write-Host ""
Write-Host "  01_docs/          - Documentation & guides" -ForegroundColor White
Write-Host "  02_examples/      - Demos & usage examples" -ForegroundColor White
Write-Host "  03_data/          - Sample datasets" -ForegroundColor White
Write-Host "  04_scripts/       - Utility scripts" -ForegroundColor White
Write-Host "  05_tests/         - Test suite" -ForegroundColor White
Write-Host "  06_configs/       - Configuration files" -ForegroundColor White
Write-Host "  insights_agent/   - Python source code" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  Next: Run .\update_references.ps1 to fix all file paths" -ForegroundColor Yellow
