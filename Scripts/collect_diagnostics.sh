#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPORT_DIR="$BASE_DIR/Reports"

mkdir -p "$REPORT_DIR"

HOSTNAME=$(hostname)
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$REPORT_DIR/system_report_${HOSTNAME}_${DATE}.txt"

{
  echo "======================================="
  echo "        Linux System Diagnostic Report"
  echo "======================================="
  echo
  echo "Hostname: $HOSTNAME"
  echo "Date: $(date)"
  echo
  echo "----- OS Information -----"
  uname -a
  lsb_release -a 2>/dev/null
  echo
  echo "----- CPU Info -----"
  lscpu
  echo
  echo "----- Memory Info -----"
  free -h
  echo
  echo "----- Disk Layout -----"
  lsblk
  echo
  echo "----- Mounted Filesystems -----"
  df -h
  echo
  echo "----- Network Interfaces -----"
  ip a
  echo
  echo "----- Running Processes (Top 15 by CPU) -----"
  ps aux --sort=-%cpu | head -n 15
  echo
} >"$REPORT_FILE"

echo "Report saved to:"
echo "$REPORT_FILE"
