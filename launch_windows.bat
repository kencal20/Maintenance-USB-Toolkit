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
echo 5) Open Scripts Folder
echo 6) Run Full Diagnostics Report
echo 0) Exit
echo.

set /p choice=Select option: 

REM Ensure Reports folder exists
set "BASE_DIR=%~dp0"
if not exist "%BASE_DIR%Reports" mkdir "%BASE_DIR%Reports"

REM Fix timestamp generation - Windows compatible
REM Get date components safely
for /f "tokens=1-3 delims=/ " %%a in ('echo %DATE%') do (
    set YY=%%c
    set MM=%%a
    set DD=%%b
)

REM If above format fails, try alternative format
if "!YY!"=="" (
    for /f "tokens=1-3 delims=-" %%a in ('echo %DATE%') do (
        set YY=%%a
        set MM=%%b
        set DD=%%c
    )
)

REM Get time components
for /f "tokens=1-2 delims=: " %%a in ('echo %TIME%') do (
    set HH=%%a
    set MIN=%%b
)

REM Remove any spaces and pad with zeros
set HH=00!HH!
set HH=!HH:~-2!
set MIN=00!MIN!
set MIN=!MIN:~-2!

REM Clean up date - remove any remaining special characters
set YY=!YY:/=!
set YY=!YY:-=!
set MM=!MM:/=!
set MM=!MM:-=!
set DD=!DD:/=!
set DD=!DD:-=!

REM Create timestamp
set TIMESTAMP=!YY!!MM!!DD!_!HH!!MIN!

REM Clean computer name (remove any invalid characters)
set "CLEAN_COMPUTER=%COMPUTERNAME%
set CLEAN_COMPUTER=!CLEAN_COMPUTER:-=_!
set CLEAN_COMPUTER=!CLEAN_COMPUTER: =_!

REM Set report file path
set "REPORT_FILE=%BASE_DIR%Reports\Report_Windows_!CLEAN_COMPUTER!_%USERNAME%_!TIMESTAMP!.txt"

REM Remove any double quotes or problematic characters
set REPORT_FILE=!REPORT_FILE:"=!
set REPORT_FILE=!REPORT_FILE:'=!

echo Report will be saved to: !REPORT_FILE!

if "%choice%"=="1" call :system_info
if "%choice%"=="2" call :disk_check
if "%choice%"=="3" call :network_info
if "%choice%"=="4" call :clean_temp
if "%choice%"=="5" call :open_scripts
if "%choice%"=="6" call :full_diagnostic
if "%choice%"=="0" exit /b

echo.
pause
goto menu

:system_info
(
    echo === System Information ===
    echo Computer: %COMPUTERNAME%
    echo User: %USERNAME%
    echo Timestamp: %DATE% %TIME%
    echo.
    echo --- OS Version ---
    ver
    echo.
    echo --- System Info ---
    systeminfo
    echo.
    echo --- Environment Variables ---
    set
) > "%REPORT_FILE%" 2>&1
echo System information saved to %REPORT_FILE%
goto :eof

:disk_check
(
    echo === Disk Information ===
    echo Computer: %COMPUTERNAME%
    echo User: %USERNAME%
    echo Timestamp: %DATE% %TIME%
    echo.
    echo --- Logical Disks ---
    wmic logicaldisk get name,description,filesystem,size,freespace
    echo.
    echo --- Disk Volumes ---
    fsutil fsinfo drives
    echo.
    echo --- Disk Usage (C: root) ---
    dir C:\
) > "%REPORT_FILE%" 2>&1
echo Disk information saved to %REPORT_FILE%
goto :eof

:network_info
(
    echo === Network Information ===
    echo Computer: %COMPUTERNAME%
    echo User: %USERNAME%
    echo Timestamp: %DATE% %TIME%
    echo.
    echo --- IP Configuration ---
    ipconfig /all
    echo.
    echo --- Network Connections ---
    netstat -an
    echo.
    echo --- Network Interfaces ---
    wmic nic get name,netenabled,macaddress,speed
) > "%REPORT_FILE%" 2>&1
echo Network information saved to %REPORT_FILE%
goto :eof

:clean_temp
(
    echo === Cleaning Temporary Files ===
    echo Computer: %COMPUTERNAME%
    echo User: %USERNAME%
    echo Timestamp: %DATE% %TIME%
    echo.
    echo Cleaning Windows Temp folder...
) > "%REPORT_FILE%" 2>&1

if exist "%TEMP%" (
    del /q /f "%TEMP%\*.*" >> "%REPORT_FILE%" 2>&1
    for /d %%p in ("%TEMP%\*") do rmdir /s /q "%%p" >> "%REPORT_FILE%" 2>&1
    echo Temp folder cleaned. >> "%REPORT_FILE%" 2>&1
) else (
    echo TEMP folder not found >> "%REPORT_FILE%" 2>&1
)

if exist "C:\Windows\Prefetch" (
    del /q /f "C:\Windows\Prefetch\*.*" >> "%REPORT_FILE%" 2>&1
    echo Prefetch cleaned. >> "%REPORT_FILE%" 2>&1
)

echo Temporary files cleaned - see %REPORT_FILE% for details
goto :eof

:open_scripts
start "" "%BASE_DIR%Scripts"
echo Opening Scripts folder...
timeout /t 2 >nul
goto :eof

:full_diagnostic
(
    echo ================================
    echo    FULL DIAGNOSTICS REPORT
    echo ================================
    echo Generated on: %DATE% %TIME%
    echo Computer: %COMPUTERNAME%
    echo User: %USERNAME%
    echo ================================
    echo.
    echo [SYSTEM INFORMATION]
    echo --------------------
    ver
    echo.
    systeminfo
    echo.
    echo.
    echo [DISK INFORMATION]
    echo ------------------
    wmic logicaldisk get name,description,filesystem,size,freespace
    echo.
    fsutil fsinfo drives
    echo.
    echo.
    echo [NETWORK INFORMATION]
    echo ---------------------
    ipconfig /all
    echo.
    netstat -an
    echo.
    echo.
    echo [RUNNING PROCESSES]
    echo -------------------
    tasklist
    echo.
    echo.
    echo [INSTALLED SOFTWARE]
    echo --------------------
    wmic product get name,version,vendor
    echo.
    echo.
    echo [SERVICES]
    echo ---------
    sc query
    echo.
    echo.
    echo [ENVIRONMENT VARIABLES]
    echo -----------------------
    set
    echo.
    echo.
    echo [MEMORY INFORMATION]
    echo --------------------
    wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /Value
    echo.
    echo.
    echo [CLEANUP OPERATIONS]
    echo --------------------
) > "%REPORT_FILE%" 2>&1

REM Add cleanup section
echo Running cleanup... >> "%REPORT_FILE%" 2>&1
if exist "%TEMP%" (
    del /q /f "%TEMP%\*.*" >> "%REPORT_FILE%" 2>&1
    echo Temp folder cleaned >> "%REPORT_FILE%" 2>&1
)

echo ================================ >> "%REPORT_FILE%" 2>&1
echo END OF REPORT >> "%REPORT_FILE%" 2>&1
echo ================================ >> "%REPORT_FILE%" 2>&1

echo Full diagnostics report saved to %REPORT_FILE%
goto :eof