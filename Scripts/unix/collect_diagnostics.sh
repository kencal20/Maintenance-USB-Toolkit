#!/usr/bin/env bash
echo "=== Diagnostics ==="
echo "Top 15 processes by CPU:"
ps aux --sort=-%cpu | head -n 15
echo
echo "Mounted filesystems:"
df -h
echo
