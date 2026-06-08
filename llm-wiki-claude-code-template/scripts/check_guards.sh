#!/usr/bin/env bash
set -euo pipefail

EXPECTED_NPM="https://npm.flatt.tech/"
ACTUAL_NPM="$(npm config get registry)"

if [ "$ACTUAL_NPM" != "$EXPECTED_NPM" ]; then
  echo "NG: npm registry is $ACTUAL_NPM"
  echo "Expected: $EXPECTED_NPM"
  exit 1
fi

echo "OK: npm registry is $ACTUAL_NPM"
