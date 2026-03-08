@echo off
title Hardware Diagnostics (Windows)
setlocal enabledelayedexpansion

:: --- Setup Reports folder and timestamp ---
set "BASE_DIR=%~dp0"
set "REPORT_DIR=%BASE_DIR%Reports"
if not exist "%REPORT_DIR%" mkdir "%REPORT_DIR%"

:: Timestamp for report
for /f "tokens=1-4 delims=/ " %%a in ('echo %date%') do set DATE=%%d-%%b-%%c
for /f "tokens=1-2 delims=: " %%a in ('echo %time%') do set TIME=%%a-%%b
set "REPORT_FILE=%REPORT_DIR%\Hardware_Report_Windows_%COMPUTERNAME%_%DATE%_%TIME%.log"

echo Running hardware diagnostics...
echo Hardware diagnostics report will be saved to %REPORT_FILE%

:: --- Begin collecting hardware info ---
(
echo ======================================
echo   WINDOWS HARDWARE DIAGNOSTICS REPORT
echo ======================================
echo Hostname: %COMPUTERNAME%
echo User: %USERNAME%
echo Date: %DATE% %TIME%
echo.

:: CPU Info
echo --- CPU Information ---
wmic cpu get name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed
echo.

:: Memory Info
echo --- Memory Information ---
wmic memorychip get capacity, speed, manufacturer, partnumber
wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /Value
echo.

:: Disk Info
echo --- Disk Information ---
wmic diskdrive get model, size, status
wmic logicaldisk get name,filesystem,freespace,size
echo.

:: Network Info
echo --- Network Interfaces ---
wmic nic get name,macaddress,netenabled,speed
ipconfig /all
echo.

:: PCI Devices
echo --- PCI Devices ---
wmic path Win32_PnPEntity where "PNPDeviceID like 'PCI%%'" get Name, DeviceID
echo.

:: USB Devices
echo --- USB Devices ---
wmic path Win32_USBControllerDevice get Dependent
echo.

:: Running Processes (optional check for stress)
echo --- Running Processes ---
tasklist
echo.

) > "%REPORT_FILE%" 2>&1

echo Hardware diagnostics completed. Report saved to %REPORT_FILE%
pause
exit /b
