#!/usr/bin/env bash
set -euo pipefail

# Usage: render_assets.sh <asset-dir> <width> <height>
# Renders every temp_slide_N.html in <asset-dir> to slide_N.png at the given
# viewport size via playwright-cli, then prints the plain-text summary list
# of absolute full asset paths required by this skill's output contract.

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <asset-dir> <width> <height>" >&2
    exit 1
fi

ASSET_DIR="$1"
WIDTH="$2"
HEIGHT="$3"

shopt -s nullglob
HTML_FILES=("$ASSET_DIR"/temp_slide_*.html)
shopt -u nullglob

if [[ ${#HTML_FILES[@]} -eq 0 ]]; then
    echo "Error: no temp_slide_*.html files found in $ASSET_DIR" >&2
    exit 1
fi

IFS=$'\n' HTML_FILES=($(sort -V <<< "${HTML_FILES[*]}")); unset IFS

PATHS=()
for html_file in "${HTML_FILES[@]}"; do
    N=$(basename "$html_file" | sed -E 's/temp_slide_([0-9]+)\.html/\1/')
    PNG="$ASSET_DIR/slide_${N}.png"

    playwright-cli open "file://$html_file"
    playwright-cli resize "$WIDTH" "$HEIGHT"
    playwright-cli screenshot --filename="$PNG"
    playwright-cli close

    PATHS+=("$PNG")
done

echo "${#PATHS[@]} asset(s) generated:"
for p in "${PATHS[@]}"; do
    echo "- $p"
done
