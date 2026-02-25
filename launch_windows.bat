@echo off
title Maintenance Toolkit

echo ===============================
echo   Maintenance Toolkit (Windows)
echo ===============================
echo.
echo 1) System Information
echo 2) Disk Check
echo 3) Open Sysinternals
echo 0) Exit
echo.

set /p choice=Select option: 

if "%choice%"=="1" systeminfo
if "%choice%"=="2" chkdsk
if "%choice%"=="3" start Sysinternals
if "%choice%"=="0" exit

pause
