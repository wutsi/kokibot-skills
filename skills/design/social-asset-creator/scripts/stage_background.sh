#!/usr/bin/env bash
set -euo pipefail

# Usage: stage_background.sh <source-path-or-url> <asset-dir> <slide-index>
# Downloads (if remote) or copies (if local) a background image into the
# asset directory as bg_slide_<slide-index>.<original-extension>, preserving
# the source extension. Prints the resulting absolute local path to stdout.

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <source-path-or-url> <asset-dir> <slide-index>" >&2
    exit 1
fi

SOURCE="$1"
ASSET_DIR="$2"
SLIDE_N="$3"

EXT="${SOURCE##*.}"
DEST="$ASSET_DIR/bg_slide_${SLIDE_N}.${EXT}"

mkdir -p "$ASSET_DIR"

if [[ "$SOURCE" =~ ^https?:// ]]; then
    curl -sL "$SOURCE" -o "$DEST"
else
    cp "$SOURCE" "$DEST"
fi

echo "$DEST"
