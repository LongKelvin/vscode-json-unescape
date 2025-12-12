@echo off
REM Build and Package Extension Script (Batch version)
REM Calls the PowerShell script

echo ========================================
echo   VS Code Extension Build ^& Package
echo ========================================
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0build-and-package.ps1" %*

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Build failed with error code %ERRORLEVEL%
    pause
    exit /b %ERRORLEVEL%
)

echo.
pause
