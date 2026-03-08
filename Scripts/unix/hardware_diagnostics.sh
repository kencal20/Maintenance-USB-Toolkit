#!/usr/bin/env bash
# Scripts/unix/hardware_diagnostics.sh
# Unified hardware diagnostic script with sudo handling

echo "=== Hardware Diagnostics ==="

# Prompt for sudo once
echo "Some checks may require sudo privileges."
sudo -v || echo "⚠️ Some commands may fail without sudo access."

mkdir -p Reports
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
USERNAME=$(whoami)
REPORT_FILE="Reports/Hardware_Report_${USERNAME}_${TIMESTAMP}.log"

echo "Hardware Diagnostics Report" >"$REPORT_FILE"
echo "Generated on $(date)" >>"$REPORT_FILE"
echo >>"$REPORT_FILE"

# --- CPU Info ---
echo "=== CPU Info ===" >>"$REPORT_FILE"
lscpu >>"$REPORT_FILE" 2>&1
if command -v sensors &>/dev/null; then
  echo >>"$REPORT_FILE"
  echo "=== CPU Temperatures ===" >>"$REPORT_FILE"
  if ! sudo sensors >>"$REPORT_FILE" 2>&1; then
    echo "⚠️ CPU temperature check failed (insufficient permissions)" >>"$REPORT_FILE"
  fi
else
  echo "lm-sensors not installed; skipping CPU temperature check" >>"$REPORT_FILE"
fi

# --- Memory Info ---
echo >>"$REPORT_FILE"
echo "=== Memory Info ===" >>"$REPORT_FILE"
free -h >>"$REPORT_FILE" 2>&1
echo >>"$REPORT_FILE"
echo "=== Memory Errors (from dmesg) ===" >>"$REPORT_FILE"
if ! sudo dmesg | grep -i 'memory error' >>"$REPORT_FILE" 2>&1; then
  echo "No memory errors detected or insufficient permissions to read dmesg" >>"$REPORT_FILE"
fi

# --- Disk / Storage Info ---
echo >>"$REPORT_FILE"
echo "=== Disk Usage ===" >>"$REPORT_FILE"
df -h >>"$REPORT_FILE" 2>&1
lsblk >>"$REPORT_FILE" 2>&1

if command -v smartctl &>/dev/null; then
  echo >>"$REPORT_FILE"
  echo "=== Disk Health (S.M.A.R.T.) ===" >>"$REPORT_FILE"
  for disk in /dev/sd?; do
    echo "Disk: $disk" >>"$REPORT_FILE"
    if ! sudo smartctl -H $disk >>"$REPORT_FILE" 2>&1; then
      echo "⚠️ S.M.A.R.T. health check failed for $disk" >>"$REPORT_FILE"
    fi
    sudo smartctl -A $disk | grep -E "Reallocated_Sector_Ct|Current_Pending_Sector|Offline_Uncorrectable" >>"$REPORT_FILE" 2>&1
    echo >>"$REPORT_FILE"
  done
else
  echo "smartmontools not installed; skipping S.M.A.R.T. checks" >>"$REPORT_FILE"
fi

# --- Network Info ---
echo >>"$REPORT_FILE"
echo "=== Network Info ===" >>"$REPORT_FILE"
ip a >>"$REPORT_FILE" 2>/dev/null || ifconfig >>"$REPORT_FILE"
ip -s link >>"$REPORT_FILE" 2>&1
ping -c 3 8.8.8.8 >>"$REPORT_FILE" 2>&1 || echo "Ping test failed" >>"$REPORT_FILE"

# --- GPU Info ---
echo >>"$REPORT_FILE"
echo "=== GPU Info ===" >>"$REPORT_FILE"
lspci | grep -i 'vga' >>"$REPORT_FILE" 2>&1

# --- System Logs ---
echo >>"$REPORT_FILE"
echo "=== Hardware / Kernel Logs ===" >>"$REPORT_FILE"
if ! sudo dmesg | grep -iE 'error|fail|warn' >>"$REPORT_FILE" 2>&1; then
  echo "No critical hardware errors detected or insufficient permissions" >>"$REPORT_FILE"
fi

echo >>"$REPORT_FILE"
echo "=== End of Hardware Diagnostics ===" >>"$REPORT_FILE"

echo "Hardware diagnostics completed. Report saved to $REPORT_FILE"
