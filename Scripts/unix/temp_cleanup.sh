#!/usr/bin/env bash
echo "=== Cleaning /tmp ==="
if sudo rm -rf /tmp/* 2>/dev/null; then
  echo "Temp folder cleaned."
else
  echo "⚠️ Failed to clean /tmp — insufficient permissions"
fi
