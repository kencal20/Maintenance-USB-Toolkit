#!/usr/bin/env bash

#!/usr/bin/env bash
# Scripts/hardware_diagnostics.sh
# Unified hardware diagnostic script

echo "=== Hardware Diagnostics ==="

mkdir -p Reports
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
USERNAME=$(whoami)
REPORT_FILE="Reports/Hardware_Report_${USERNAME}_${TIMESTAMP}.txt"

echo "Hardware Diagnostics Report" >"$REPORT_FILE"
echo "Generated on $(date)" >>"$REPORT_FILE"
echo >>"$REPORT_FILE"

# --- CPU Info ---
echo "=== CPU Info ===" >>"$REPORT_FILE"
lscpu >>"$REPORT_FILE"
if command -v sensors &>/dev/null; then
  echo >>"$REPORT_FILE"
  echo "=== CPU Temperatures ===" >>"$REPORT_FILE"
  sensors >>"$REPORT_FILE"
else
  echo "lm-sensors not installed; skipping CPU temperature check" >>"$REPORT_FILE"
fi

# --- Memory Info ---
echo >>"$REPORT_FILE"
echo "=== Memory Info ===" >>"$REPORT_FILE"
free -h >>"$REPORT_FILE"
echo >>"$REPORT_FILE"
echo "=== Memory Errors (from dmesg) ===" >>"$REPORT_FILE"
dmesg | grep -i 'memory error' >>"$REPORT_FILE" || echo "No memory errors detected" >>"$REPORT_FILE"

# --- Disk / Storage Info ---
echo >>"$REPORT_FILE"
echo "=== Disk Usage ===" >>"$REPORT_FILE"
df -h >>"$REPORT_FILE"
lsblk >>"$REPORT_FILE"

if command -v smartctl &>/dev/null; then
  echo >>"$REPORT_FILE"
  echo "=== Disk Health (S.M.A.R.T.) ===" >>"$REPORT_FILE"
  for disk in /dev/sd?; do
    echo "Disk: $disk" >>"$REPORT_FILE"
    sudo smartctl -H $disk >>"$REPORT_FILE" 2>&1
    sudo smartctl -A $disk | grep -E "Reallocated_Sector_Ct|Current_Pending_Sector|Offline_Uncorrectable" >>"$REPORT_FILE"
    echo >>"$REPORT_FILE"
  done
else
  echo "smartmontools not installed; skipping S.M.A.R.T. checks" >>"$REPORT_FILE"
fi

# --- Network Info ---
echo >>"$REPORT_FILE"
echo "=== Network Info ===" >>"$REPORT_FILE"
ip a >>"$REPORT_FILE" 2>/dev/null || ifconfig >>"$REPORT_FILE"
ip -s link >>"$REPORT_FILE"
ping -c 3 8.8.8.8 >>"$REPORT_FILE" 2>&1 || echo "Ping test failed" >>"$REPORT_FILE"

# --- GPU Info ---
echo >>"$REPORT_FILE"
echo "=== GPU Info ===" >>"$REPORT_FILE"
lspci | grep -i 'vga' >>"$REPORT_FILE"

# --- System Logs ---
echo >>"$REPORT_FILE"
echo "=== Hardware / Kernel Logs ===" >>"$REPORT_FILE"
dmesg | grep -iE 'error|fail|warn' >>"$REPORT_FILE" || echo "No critical hardware errors detected" >>"$REPORT_FILE"

echo >>"$REPORT_FILE"
echo "=== End of Hardware Diagnostics ===" >>"$REPORT_FILE"

echo "Hardware diagnostics completed. Report saved to $REPORT_FILE"
