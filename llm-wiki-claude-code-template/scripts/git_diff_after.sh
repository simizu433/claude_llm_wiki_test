#!/usr/bin/env bash
set -euo pipefail

mkdir -p .claude-work

git status --short > .claude-work/status.after.txt || true
git diff --name-only > .claude-work/changed-files.after.txt || true
git diff > .claude-work/diff.after.patch || true

echo "Saved after-state to .claude-work/"
echo "Changed files:"
cat .claude-work/changed-files.after.txt || true
