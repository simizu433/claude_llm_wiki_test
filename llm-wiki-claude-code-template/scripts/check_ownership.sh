#!/usr/bin/env bash
set -euo pipefail

echo "user: $(whoami 2>/dev/null || true)"
echo "id: $(id)"
echo "home: ${HOME:-}"
echo "workspace owner: $(stat -c '%U:%G %u:%g' /workspace)"

touch /workspace/.ownership-test
rm /workspace/.ownership-test

echo "OK: workspace is writable"
