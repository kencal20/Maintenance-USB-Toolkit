#!/usr/bin/env bash
# Unix/Linux/macOS Maintenance Launcher

OS_TYPE=$(uname)
case "$OS_TYPE" in
Linux) PLATFORM="Linux" ;;
Darwin) PLATFORM="macOS" ;;
FreeBSD | OpenBSD | NetBSD) PLATFORM="$OS_TYPE" ;;
*)
  echo "Unsupported OS: $OS_TYPE"
  exit 1
  ;;
esac

# Prompt for sudo once at the start if needed
echo "Some operations may require sudo privileges."
sudo -v || { echo "⚠️ Sudo access is required for certain operations."; }

clear
echo "==============================="
echo " Maintenance Toolkit ($PLATFORM)"
echo "==============================="
echo
echo "1) System Information"
echo "2) Disk Usage"
echo "3) Network Information"
echo "4) Clean Temporary Files"
echo "5) Clear Package Cache"
echo "6) Hardware Diagnostics"
echo "7) Open Scripts Folder"
echo "8) Run Full Diagnostics Report"
echo "0) Exit"
echo

read -p "Select option: " choice
mkdir -p Reports
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
USERNAME=$(whoami)
REPORT_FILE="Reports/Report_${PLATFORM}_${USERNAME}_${TIMESTAMP}.log"

case $choice in
1) bash ./Scripts/unix/system_info.sh >>"$REPORT_FILE" ;;
2) bash ./Scripts/unix/disk_usage.sh >>"$REPORT_FILE" ;;
3) bash ./Scripts/unix/network_info.sh >>"$REPORT_FILE" ;;
4) bash ./Scripts/unix/temp_cleanup.sh >>"$REPORT_FILE" ;;
5) bash ./Scripts/unix/package_cache_cleanup.sh >>"$REPORT_FILE" ;;
6) bash ./Scripts/unix/hardware_diagnostics.sh >>"$REPORT_FILE" ;;
7) xdg-open ./Scripts/unix 2>/dev/null || open ./Scripts/unix ;;
8)
  echo "=== Full Diagnostics ===" >"$REPORT_FILE"
  bash ./Scripts/unix/system_info.sh >>"$REPORT_FILE"
  bash ./Scripts/unix/disk_usage.sh >>"$REPORT_FILE"
  bash ./Scripts/unix/network_info.sh >>"$REPORT_FILE"
  bash ./Scripts/unix/temp_cleanup.sh >>"$REPORT_FILE"
  bash ./Scripts/unix/package_cache_cleanup.sh >>"$REPORT_FILE"
  bash ./Scripts/unix/hardware_diagnostics.sh >>"$REPORT_FILE"
  echo "Full diagnostics saved to $REPORT_FILE"
  ;;
0) exit ;;
*) echo "Invalid option." ;;
esac

echo
read -p "Press Enter to exit..."

