@echo off

set BASE_DIR=%~dp0..
set REPORT_DIR=%BASE_DIR%\Reports

if not exist "%REPORT_DIR%" mkdir "%REPORT_DIR%"

set HOSTNAME=%COMPUTERNAME%
for /f "tokens=1-4 delims=/ " %%a in ("%date%") do set DATE=%%d-%%b-%%c
for /f "tokens=1-2 delims=: " %%a in ("%time%") do set TIME=%%a-%%b

set REPORT_FILE=%REPORT_DIR%\system_report_%HOSTNAME%_%DATE%_%TIME%.txt

(
echo =======================================
echo        Windows System Diagnostic Report
echo =======================================
echo.
echo Hostname: %HOSTNAME%
echo Date: %date% %time%
echo.
echo ----- System Info -----
systeminfo
echo.
echo ----- Disk Info -----
wmic logicaldisk get name,freespace,size
echo.
echo ----- Memory Info -----
wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /Value
echo.
echo ----- Network Config -----
ipconfig /all
echo.
echo ----- Running Processes -----
tasklist
) > "%REPORT_FILE%"

echo Report saved to:
echo %REPORT_FILE%
pause
