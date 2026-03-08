#!/usr/bin/env bash
echo "=== Clearing Package Cache ==="
if command -v apt-get &>/dev/null; then
  sudo apt-get clean || echo "⚠️ apt-get clean failed"
fi
if command -v yum &>/dev/null; then
  sudo yum clean all || echo "⚠️ yum clean failed"
fi
if command -v brew &>/dev/null; then
  brew cleanup || echo "⚠️ brew cleanup failed"
fi
