@echo off
REM Quick setup script for Windows
REM Run as Administrator: .\setup.bat

echo === Host UK Developer Workspace Setup ===
echo.

REM Check for admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Please run this script as Administrator
    echo Right-click and select "Run as administrator"
    pause
    exit /b 1
)

REM Install dependencies
echo Installing dependencies...
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\install-deps.ps1"
if %errorlevel% neq 0 goto :error

REM Install core CLI
echo.
echo Installing core CLI...
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\install-core.ps1"
if %errorlevel% neq 0 goto :error

REM Refresh PATH
set "PATH=%PATH%;%LOCALAPPDATA%\Programs\core"

REM Run doctor
echo.
echo === Verifying environment ===
core doctor

REM Clone repos
echo.
echo === Cloning repositories ===
core setup

echo.
echo === Setup complete! ===
echo Run 'core health' to check status
pause
exit /b 0

:error
echo.
echo Setup failed! Check the error above.
pause
exit /b 1
