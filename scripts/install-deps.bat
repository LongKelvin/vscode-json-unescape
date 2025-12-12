@echo off
REM Install Dependencies Script (Batch version)
REM Calls the PowerShell script

echo Installing dependencies...
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0install-deps.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Installation failed with error code %ERRORLEVEL%
    pause
    exit /b %ERRORLEVEL%
)

echo.
pause
