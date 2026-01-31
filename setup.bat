@echo off
setlocal enabledelayedexpansion
REM Quick setup script for Windows
REM Run as Administrator: setup.bat
REM
REM SECURITY: This script validates environment before executing
REM to prevent path manipulation attacks.

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

REM === SECURITY: Validate LOCALAPPDATA ===
REM Ensure LOCALAPPDATA is set and appears to be within user profile
if "%LOCALAPPDATA%"=="" (
    echo ERROR: LOCALAPPDATA environment variable is not set
    goto :error
)

if "%USERPROFILE%"=="" (
    echo ERROR: USERPROFILE environment variable is not set
    goto :error
)

REM Check that LOCALAPPDATA starts with USERPROFILE (basic validation)
REM This prevents redirection attacks where LOCALAPPDATA points elsewhere
echo !LOCALAPPDATA! | findstr /i /b /c:"!USERPROFILE!" >nul
if !errorlevel! neq 0 (
    echo ERROR: LOCALAPPDATA does not appear to be within user profile
    echo LOCALAPPDATA: !LOCALAPPDATA!
    echo USERPROFILE: !USERPROFILE!
    echo This may indicate a path manipulation attack. Aborting.
    goto :error
)

REM Validate paths don't contain suspicious characters that could enable injection
REM Blocks: < > | & ^ ` %% (shell metacharacters)
echo !LOCALAPPDATA! | findstr /r "[<>|&^`]" >nul
if !errorlevel! equ 0 (
    echo ERROR: LOCALAPPDATA contains invalid shell characters
    goto :error
)
REM Check for percent signs (both single and double)
set "TEMP_CHECK=!LOCALAPPDATA!"
set "TEMP_CHECK=!TEMP_CHECK:%%=!"
if not "!TEMP_CHECK!"=="!LOCALAPPDATA!" (
    echo ERROR: LOCALAPPDATA contains percent signs
    goto :error
)

REM === Install dependencies ===
echo Installing dependencies...
call powershell -ExecutionPolicy Bypass -File "%~dp0scripts\install-deps.ps1"
if !errorlevel! neq 0 goto :error

REM === Install core CLI ===
echo.
echo Installing core CLI...
call powershell -ExecutionPolicy Bypass -File "%~dp0scripts\install-core.ps1"
if !errorlevel! neq 0 goto :error

REM === Validate install path before use ===
set "CORE_PATH=!LOCALAPPDATA!\Programs\core"

REM Verify the path exists and is a directory (not a symlink to elsewhere)
if not exist "!CORE_PATH!\core.exe" (
    echo ERROR: core.exe not found at !CORE_PATH!\core.exe
    goto :error
)

REM Check if it's a symlink/junction using fsutil (more reliable than attributes)
fsutil reparsepoint query "!CORE_PATH!" >nul 2>&1
if !errorlevel! equ 0 (
    echo ERROR: Install directory is a reparse point (symlink or junction^)
    echo This may indicate a symlink attack. Aborting.
    goto :error
)

REM Fallback: also check attributes for symlink indicator
for %%F in ("!CORE_PATH!") do (
    set "ATTRS=%%~aF"
)
echo !ATTRS! | findstr /c:"l" >nul
if !errorlevel! equ 0 (
    echo ERROR: Install directory appears to be a symbolic link
    echo This may indicate a symlink attack. Aborting.
    goto :error
)

REM Refresh PATH for this session
set "PATH=%PATH%;!CORE_PATH!"

REM === Run doctor ===
echo.
echo === Verifying environment ===
call "!CORE_PATH!\core.exe" doctor
if !errorlevel! neq 0 (
    echo WARNING: core doctor reported issues
)

REM === Clone repos ===
echo.
echo === Cloning repositories ===
call "!CORE_PATH!\core.exe" setup
if !errorlevel! neq 0 goto :error

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
