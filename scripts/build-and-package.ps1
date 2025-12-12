# Build and Package Extension Script
# Automatically builds and packages the VS Code extension

param(
    [switch]$SkipInstall
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  VS Code Extension Build & Package" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Install dependencies
if (!$SkipInstall) {
    Write-Host "[1/4] Installing dependencies..." -ForegroundColor Yellow
    & "$PSScriptRoot\install-deps.ps1"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Dependency installation failed!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[1/4] Skipping dependency installation..." -ForegroundColor Yellow
}

Write-Host ""

# Step 2: Clean previous build
Write-Host "[2/4] Cleaning previous build..." -ForegroundColor Yellow
if (Test-Path "out") {
    Remove-Item -Recurse -Force "out"
    Write-Host "  Removed 'out' directory" -ForegroundColor Gray
}
if (Test-Path "*.vsix") {
    Remove-Item -Force "*.vsix"
    Write-Host "  Removed old .vsix files" -ForegroundColor Gray
}
Write-Host "  ✓ Clean complete" -ForegroundColor Green

Write-Host ""

# Step 3: Compile TypeScript
Write-Host "[3/4] Compiling TypeScript..." -ForegroundColor Yellow
npm run compile
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Compilation failed!" -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ Compilation successful" -ForegroundColor Green

Write-Host ""

# Step 4: Package extension
Write-Host "[4/4] Packaging extension..." -ForegroundColor Yellow

# Check if vsce is installed
$vsceInstalled = Get-Command vsce -ErrorAction SilentlyContinue
if (!$vsceInstalled) {
    Write-Host "  vsce not found. Installing @vscode/vsce globally..." -ForegroundColor Yellow
    npm install -g @vscode/vsce --force
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Failed to install vsce!" -ForegroundColor Red
        exit 1
    }
}

# Package the extension
vsce package
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Packaging failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  ✓ Build & Package Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Find and display the .vsix file
$vsixFile = Get-ChildItem -Filter "*.vsix" | Select-Object -First 1
if ($vsixFile) {
    Write-Host "Package created: $($vsixFile.Name)" -ForegroundColor Cyan
    Write-Host "Location: $($vsixFile.FullName)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "To install locally:" -ForegroundColor Yellow
    Write-Host "  code --install-extension $($vsixFile.Name)" -ForegroundColor White
}
