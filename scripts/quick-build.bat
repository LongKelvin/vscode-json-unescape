@echo off
REM Quick Build Script (Batch version)

echo Compiling TypeScript...
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0quick-build.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Compilation failed with error code %ERRORLEVEL%
    pause
    exit /b %ERRORLEVEL%
)

echo.
pause
