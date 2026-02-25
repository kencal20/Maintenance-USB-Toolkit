#!/usr/bin/env bash

clear
echo "==============================="
echo "   Maintenance Toolkit (Linux)"
echo "==============================="
echo
echo "1) System Information"
echo "2) Disk Usage"
echo "3) Network Information"
echo "4) Open Scripts Folder"
echo "0) Exit"
echo

read -p "Select option: " choice

case $choice in
1)
  uname -a
  echo
  lsb_release -a 2>/dev/null
  ;;
2) df -h ;;
3) ip a ;;
4) xdg-open "$(dirname "$0")/Scripts" ;;
0) exit ;;
*) echo "Invalid option." ;;
esac

echo
read -p "Press Enter to exit..."
