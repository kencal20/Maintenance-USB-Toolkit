@echo off
title Maintenance Toolkit (Windows)

REM Set base directory of the script
set "BASE_DIR=%~dp0"

REM Ensure Reports folder exists
if not exist "%BASE_DIR%Reports" mkdir "%BASE_DIR%Reports"

REM Enable delayed expansion for variables
setlocal enabledelayedexpansion

REM Generate timestamp
set TIMESTAMP=%DATE:~-4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
set REPORT_FILE=%BASE_DIR%Reports\Report_Windows_%USERNAME%_%TIMESTAMP%.txt
set REPORT_FILE=%REPORT_FILE: =0%

echo.
echo 1) System Information
echo 2) Disk Check
echo 3) Network Information
echo 4) Clean Temporary Files
echo 5) Open Scripts Folder
echo 6) Run Full Diagnostics Report
echo 0) Exit
echo.

set /p choice=Select option: 

REM === Option 1: System Information ===
if "%choice%"=="1" (
    echo === System Information === >> "%REPORT_FILE%"
    echo Computer: %COMPUTERNAME% >> "%REPORT_FILE%"
    echo User: %USERNAME% >> "%REPORT_FILE%"
    systeminfo >> "%REPORT_FILE%"
    echo Report saved to %REPORT_FILE%
)

REM === Option 2: Disk Check ===
if "%choice%"=="2" (
    echo === Disk Info === >> "%REPORT_FILE%"
    wmic logicaldisk get name,freespace,size >> "%REPORT_FILE%"
    echo Report saved to %REPORT_FILE%
)

REM === Option 3: Network Information ===
if "%choice%"=="3" (
    echo === Network Info === >> "%REPORT_FILE%"
    ipconfig /all >> "%REPORT_FILE%"
    echo Report saved to %REPORT_FILE%
)

REM === Option 4: Clean Temporary Files ===
if "%choice%"=="4" (
    echo === Cleaning Temp Files === >> "%REPORT_FILE%"
    del /q /f "%TEMP%\*.*" >> "%REPORT_FILE%" 2>&1
    echo Temp folder cleaned. >> "%REPORT_FILE%"
    echo Action logged in %REPORT_FILE%
)

REM === Option 5: Open Scripts Folder ===
if "%choice%"=="5" (
    start "" "%BASE_DIR%\Scripts"
)

REM === Option 6: Full Diagnostics Report ===
if "%choice%"=="6" (
    echo === Full Diagnostics Report === > "%REPORT_FILE%"
    echo Report generated on: %DATE% %TIME% >> "%REPORT_FILE%"
    echo. >> "%REPORT_FILE%"

    echo === System Info === >> "%REPORT_FILE%"
    systeminfo >> "%REPORT_FILE%"
    echo. >> "%REPORT_FILE%"

    echo === Disk Info === >> "%REPORT_FILE%"
    wmic logicaldisk get name,freespace,size >> "%REPORT_FILE%"
    echo. >> "%REPORT_FILE%"

    echo === Network Info === >> "%REPORT_FILE%"
    ipconfig /all >> "%REPORT_FILE%"
    echo. >> "%REPORT_FILE%"

    echo === Temp Cleanup === >> "%REPORT_FILE%"
    del /q /f "%TEMP%\*.*" >> "%REPORT_FILE%" 2>&1
    echo Temp folder cleaned. >> "%REPORT_FILE%"

    echo Full diagnostics report saved to %REPORT_FILE%
)

REM === Option 0: Exit ===
if "%choice%"=="0" exit

echo.
pause