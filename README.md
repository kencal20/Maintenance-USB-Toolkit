# 🛠️ Maintenance Toolkit USB
**Version:** 1.1  
**Author:** kencal20  
**Purpose:** Cross-platform system diagnostics, hardware reporting, and maintenance utilities.

---

## 📂 Project Structure
The toolkit is divided into platform-specific logic and a centralized reporting system:

- **Launchers:** Root-level scripts (`launch_unix.sh`, `launch_windows.bat`) provide an interactive menu for the user.
- **Scripts/unix/:** Bash scripts for Linux/macOS (System info, disk usage, temp cleanup, and advanced hardware diagnostics).
- **Scripts/windows/:** Batch scripts for Windows (WMIC-based hardware reporting and system diagnostics).
- **Reports/:** Automatically created folder where all diagnostic logs are stored with timestamps.
- **Sysinternals/:** Reserved for Windows advanced utilities.

---

## 🚀 How It Works

### 🐧 Unix / Linux / macOS
The `launch_unix.sh` script detects your OS flavor (Linux, Darwin, etc.) and provides a wrapper for the sub-scripts. 
* **Permissions:** It proactively checks for `sudo` to ensure tasks like clearing `/tmp` or running `smartctl` don't fail silently.
* **Key Feature:** The `hardware_diagnostics.sh` is highly robust, checking CPU temps, S.M.A.R.T. disk health, and kernel logs (`dmesg`).

### 🪟 Windows
The `launch_windows.bat` uses a `setlocal enabledelayedexpansion` environment to handle dynamic variables (like timestamps) inside the menu loop.
* **Logic:** It leverages `WMIC` (Windows Management Instrumentation) to pull deep hardware specs without needing 3rd-party binaries.
* **Key Feature:** Unified reporting—the "Full Diagnostics" option aggregates System, Disk, Memory, and Network info into a single log file.

---

## 🛠️ Included Tools

| Feature | Unix Script | Windows Script |
| :--- | :--- | :--- |
| **System Info** | `system_info.sh` | `system_info.bat` |
| **Hardware Health** | `hardware_diagnostics.sh` | `hardware_diagnostics.bat` |
| **Disk Management** | `disk_usage.sh` | `disk_check.bat` |
| **Cleanup** | `temp_cleanup.sh` | `clean_temp.bat` |
| **Network** | `network_info.sh` | `network_info.bat` |

---

## 📝 Usage Notes
1. **Report Generation:** Every time you run a diagnostic, a `.log` file is generated in the `Reports/` folder using the format: `Report_[Platform]_[User]_[Timestamp].log`.
2. **Portability:** This entire directory can be dropped onto a FAT32/exFAT USB drive and run on almost any machine.
3. **Dependencies:** - Linux: Best results if `smartmontools` and `lm-sensors` are installed.
   - Windows: Requires Command Prompt (CMD) with Admin rights for certain WMIC queries.

---
*Last Updated: March 2026*
