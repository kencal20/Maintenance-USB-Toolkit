#!/usr/bin/env bash
echo "=== Network Info ==="
ip a 2>/dev/null || ifconfig
