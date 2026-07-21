#!/usr/bin/env bash
set -euo pipefail

if ! command -v playwright-cli &> /dev/null; then
    echo "Error: playwright-cli is not installed or not found in PATH." >&2
    echo "Please install Playwright CLI before running this skill (e.g., npm install -g @playwright/cli@latest)." >&2
    exit 1
fi
