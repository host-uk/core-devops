@echo off
setlocal enabledelayedexpansion
REM Quick setup script for Windows
REM Run as Administrator: setup.bat

echo === Host UK Developer Workspace Setup ===
echo.

REM Check for admin rights
net session >nul 2>&1
if !errorlevel! neq 0 (
    echo ERROR: Please run this script as Administrator
    echo Right-click and select "Run as administrator"
    pause
    exit /b 1
)

REM Install dependencies
echo Installing dependencies...
call powershell -ExecutionPolicy Bypass -File "%~dp0scripts\install-deps.ps1"
if !errorlevel! neq 0 goto :error

REM Install core CLI
echo.
echo Installing core CLI...
call powershell -ExecutionPolicy Bypass -File "%~dp0scripts\install-core.ps1"
if !errorlevel! neq 0 goto :error

REM Refresh PATH
set "PATH=%PATH%;%LOCALAPPDATA%\Programs\core"

REM Verify core.exe exists before running
if not exist "%LOCALAPPDATA%\Programs\core\core.exe" (
    echo ERROR: core.exe not found at %LOCALAPPDATA%\Programs\core\core.exe
    goto :error
)

REM Run doctor
echo.
echo === Verifying environment ===
call "%LOCALAPPDATA%\Programs\core\core.exe" doctor

REM Clone repos
echo.
echo === Cloning repositories ===
call "%LOCALAPPDATA%\Programs\core\core.exe" setup

echo.
echo === Setup complete! ===
echo Run 'core health' to check status
pause
endlocal
exit /b 0

:error
echo.
echo Setup failed! Check the error above.
pause
endlocal
exit /b 1
