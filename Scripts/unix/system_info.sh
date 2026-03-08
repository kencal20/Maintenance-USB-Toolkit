#!/usr/bin/env bash
echo "=== System Info ==="
echo "OS: $(uname -s) $(uname -r)"
lsb_release -a 2>/dev/null
lscpu | grep 'Model name'
free -h
