# Quick Build Script - Compile only (no package)
# Useful for rapid development and testing

Write-Host "Compiling TypeScript..." -ForegroundColor Cyan

npm run compile

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✓ Compilation successful!" -ForegroundColor Green
    Write-Host "Press F5 in VS Code to test the extension" -ForegroundColor Yellow
} else {
    Write-Host "`n✗ Compilation failed!" -ForegroundColor Red
    exit 1
}
