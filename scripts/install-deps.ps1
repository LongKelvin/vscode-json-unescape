# Install Dependencies Script
# Automatically installs missing npm packages

Write-Host "Installing dependencies..." -ForegroundColor Cyan

# Check if node_modules exists
if (!(Test-Path "node_modules")) {
    Write-Host "node_modules not found. Running npm install..." -ForegroundColor Yellow
    npm install
} else {
    Write-Host "Checking for missing packages..." -ForegroundColor Yellow
    
    # Read package.json
    $packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json
    
    # Check devDependencies
    $missingPackages = @()
    
    if ($packageJson.devDependencies) {
        foreach ($package in $packageJson.devDependencies.PSObject.Properties) {
            $packageName = $package.Name
            $packagePath = "node_modules\$packageName"
            
            if (!(Test-Path $packagePath)) {
                $missingPackages += $packageName
                Write-Host "  Missing: $packageName" -ForegroundColor Red
            }
        }
    }
    
    # Check dependencies
    if ($packageJson.dependencies) {
        foreach ($package in $packageJson.dependencies.PSObject.Properties) {
            $packageName = $package.Name
            $packagePath = "node_modules\$packageName"
            
            if (!(Test-Path $packagePath)) {
                $missingPackages += $packageName
                Write-Host "  Missing: $packageName" -ForegroundColor Red
            }
        }
    }
    
    # Install missing packages or verify
    if ($missingPackages.Count -gt 0) {
        Write-Host "`nInstalling missing packages..." -ForegroundColor Yellow
        npm install
    } else {
        Write-Host "All packages are already installed!" -ForegroundColor Green
        
        # Run npm install to ensure everything is up to date
        Write-Host "`nVerifying installation..." -ForegroundColor Yellow
        npm install
    }
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✓ Dependencies installed successfully!" -ForegroundColor Green
} else {
    Write-Host "`n✗ Failed to install dependencies!" -ForegroundColor Red
    exit 1
}
