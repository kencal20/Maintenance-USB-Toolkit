@echo off
title Maintenance Toolkit (Windows)
setlocal enabledelayedexpansion

:menu
cls
echo ===============================
echo    Maintenance Toolkit (Windows)
echo ===============================
echo.
echo 1) System Information
echo 2) Disk Check
echo 3) Network Information
echo 4) Clean Temporary Files
echo 5) Hardware Diagnostics
echo 6) Open Scripts Folder
echo 7) Run Full Diagnostics Report
echo 0) Exit
echo.

set /p choice=Select option:

set "BASE_DIR=%~dp0"
if not exist "%BASE_DIR%Reports" mkdir "%BASE_DIR%Reports"

REM Timestamp for report
for /f "tokens=1-3 delims=/ " %%a in ('echo %DATE%') do (
    set YY=%%c
    set MM=%%a
    set DD=%%b
)
for /f "tokens=1-2 delims=: " %%a in ('echo %TIME%') do (
    set HH=%%a
    set MIN=%%b
)
set HH=00!HH!
set HH=!HH:~-2!
set MIN=00!MIN!
set MIN=!MIN:~-2!
set TIMESTAMP=!YY!!MM!!DD!_!HH!!MIN!

REM Report path
set "REPORT_FILE=%BASE_DIR%Reports\Report_Windows_%COMPUTERNAME%_%USERNAME%_!TIMESTAMP!.txt"

REM Call scripts based on choice
if "%choice%"=="1" call Scripts\windows\system_info.bat >> "!REPORT_FILE!" 2>&1
if "%choice%"=="2" call Scripts\windows\disk_check.bat >> "!REPORT_FILE!" 2>&1
if "%choice%"=="3" call Scripts\windows\network_info.bat >> "!REPORT_FILE!" 2>&1
if "%choice%"=="4" call Scripts\windows\clean_temp.bat >> "!REPORT_FILE!" 2>&1
if "%choice%"=="5" call Scripts\windows\hardware_diagnostics.bat >> "!REPORT_FILE!" 2>&1
if "%choice%"=="6" start "" "%BASE_DIR%Scripts\windows"
if "%choice%"=="7" (
    call Scripts\windows\system_info.bat >> "!REPORT_FILE!" 2>&1
    call Scripts\windows\disk_check.bat >> "!REPORT_FILE!" 2>&1
    call Scripts\windows\network_info.bat >> "!REPORT_FILE!" 2>&1
    call Scripts\windows\clean_temp.bat >> "!REPORT_FILE!" 2>&1
    call Scripts\windows\hardware_diagnostics.bat >> "!REPORT_FILE!" 2>&1
    echo Full diagnostics report saved to "!REPORT_FILE!"
)
if "%choice%"=="0" exit /b

pause
goto menu