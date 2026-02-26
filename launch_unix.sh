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
echo "6) Open Scripts Folder"
echo "7) Run Full Diagnostics Report"
echo "0) Exit"
echo

read -p "Select option: " choice
mkdir -p Reports
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
USERNAME=$(whoami)
REPORT_FILE="Reports/Report_${PLATFORM}_${USERNAME}_${TIMESTAMP}.txt"

case $choice in
1)
  echo "=== System Information ===" >>"$REPORT_FILE"
  echo "OS: $(uname -s) $(uname -r)" >>"$REPORT_FILE"
  lsb_release -a 2>/dev/null >>"$REPORT_FILE"
  lscpu | grep 'Model name' >>"$REPORT_FILE"
  free -h >>"$REPORT_FILE"
  ;;
2)
  echo "=== Disk Usage ===" >>"$REPORT_FILE"
  df -h >>"$REPORT_FILE"
  lsblk >>"$REPORT_FILE"
  ;;
3)
  echo "=== Network Information ===" >>"$REPORT_FILE"
  ip a >>"$REPORT_FILE" 2>/dev/null || ifconfig >>"$REPORT_FILE"
  ;;
4)
  echo "=== Cleaning Temporary Files ===" >>"$REPORT_FILE"
  sudo rm -rf /tmp/* >>"$REPORT_FILE" 2>&1
  echo "Temp folder cleaned." >>"$REPORT_FILE"
  ;;
5)
  echo "=== Clearing Package Cache ===" >>"$REPORT_FILE"
  if command -v apt-get &>/dev/null; then sudo apt-get clean >>"$REPORT_FILE" 2>&1; fi
  if command -v yum &>/dev/null; then sudo yum clean all >>"$REPORT_FILE" 2>&1; fi
  if command -v brew &>/dev/null; then brew cleanup >>"$REPORT_FILE" 2>&1; fi
  ;;
6)
  xdg-open ./Scripts 2>/dev/null || open ./Scripts
  ;;
7)
  echo "=== Full Diagnostics Report ===" >"$REPORT_FILE"
  echo "Generated on $(date)" >>"$REPORT_FILE"
  echo >>"$REPORT_FILE"
  echo "=== System Info ===" >>"$REPORT_FILE"
  uname -a >>"$REPORT_FILE"
  lsb_release -a 2>/dev/null >>"$REPORT_FILE"
  lscpu >>"$REPORT_FILE"
  free -h >>"$REPORT_FILE"
  echo >>"$REPORT_FILE"
  echo "=== Disk Usage ===" >>"$REPORT_FILE"
  df -h >>"$REPORT_FILE"
  lsblk >>"$REPORT_FILE"
  echo >>"$REPORT_FILE"
  echo "=== Network Info ===" >>"$REPORT_FILE"
  ip a >>"$REPORT_FILE" 2>/dev/null || ifconfig >>"$REPORT_FILE"
  echo >>"$REPORT_FILE"
  echo "=== Temp Cleanup ===" >>"$REPORT_FILE"
  sudo rm -rf /tmp/* >>"$REPORT_FILE" 2>&1
  echo "Temp folder cleaned." >>"$REPORT_FILE"
  echo >>"$REPORT_FILE"
  echo "=== Package Cache Cleanup ===" >>"$REPORT_FILE"
  if command -v apt-get &>/dev/null; then sudo apt-get clean >>"$REPORT_FILE" 2>&1; fi
  if command -v yum &>/dev/null; then sudo yum clean all >>"$REPORT_FILE" 2>&1; fi
  if command -v brew &>/dev/null; then brew cleanup >>"$REPORT_FILE" 2>&1; fi
  echo "Full diagnostics saved to $REPORT_FILE"
  ;;
0)
  exit
  ;;
*)
  echo "Invalid option."
  ;;
esac

echo
read -p "Press Enter to exit..."
