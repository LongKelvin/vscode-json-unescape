# Build Scripts

This folder contains automation scripts for building and packaging the VS Code extension.

## Available Scripts

### 1. Install Dependencies

Automatically checks and installs missing npm packages.

**PowerShell:**
```powershell
.\scripts\install-deps.ps1
```

**Batch (Windows):**
```batch
scripts\install-deps.bat
```

**NPM (cross-platform):**
```bash
npm install
```

---

### 2. Build and Package

Automatically builds and packages the extension into a `.vsix` file.

**PowerShell:**
```powershell
.\scripts\build-and-package.ps1
```

**Batch (Windows):**
```batch
scripts\build-and-package.bat
```

**NPM (cross-platform):**
```bash
npm run build
```

**Skip dependency installation:**
```powershell
.\scripts\build-and-package.ps1 -SkipInstall
```

---

## What Each Script Does

### `install-deps.ps1` / `install-deps.bat`

1. Checks if `node_modules` exists
2. Scans `package.json` for missing packages
3. Installs any missing dependencies
4. Verifies the installation

### `build-and-package.ps1` / `build-and-package.bat`

1. **Install Dependencies** - Ensures all npm packages are installed
2. **Clean** - Removes old `out` directory and `.vsix` files
3. **Compile** - Compiles TypeScript to JavaScript
4. **Package** - Creates the `.vsix` package file

The script also:
- Automatically installs `vsce` if not found
- Displays the location of the created `.vsix` file
- Shows the command to install the extension locally

---

## Quick Start

1. **First time setup:**
   ```powershell
   .\scripts\install-deps.ps1
   ```

2. **Build and package:**
   ```powershell
   .\scripts\build-and-package.ps1
   ```

3. **Install the extension:**
   ```bash
   code --install-extension json-unescape-formatter-1.0.0.vsix
   ```

---

## Troubleshooting

**PowerShell Execution Policy Error:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**vsce not found:**
The build script will automatically install it, or manually run:
```bash
npm install -g @vscode/vsce --force
```

**Build fails:**
1. Clean everything: Delete `node_modules`, `out`, and `.vsix` files
2. Run `npm install`
3. Run the build script again
