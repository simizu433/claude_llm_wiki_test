#!/usr/bin/env bash
set -euo pipefail

npm config set registry https://npm.flatt.tech/
npm install -g @anthropic-ai/claude-code

echo 'export NPM_CONFIG_PREFIX=/workspace/.npm-global' >> ~/.bashrc
echo 'export PATH=/workspace/.npm-global/bin:$PATH' >> ~/.bashrc

echo "Installed Claude Code. Run: source ~/.bashrc && claude --version"
