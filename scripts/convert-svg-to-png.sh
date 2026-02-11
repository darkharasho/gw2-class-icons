#!/bin/bash
set -euo pipefail

# Convert SVG files to PNG using ImageMagick.
# Output is always written to wiki/high-res.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

SRC_DIR="${1:-$PROJECT_DIR/wiki/svg}"
DEST_DIR="$PROJECT_DIR/wiki/high-res"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "source directory not found: $SRC_DIR" >&2
  echo "usage: bash scripts/convert-svg-to-png.sh [source_dir]" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"

shopt -s nullglob
files=("$SRC_DIR"/*.svg)

if [[ ${#files[@]} -eq 0 ]]; then
  echo "no .svg files found in $SRC_DIR" >&2
  exit 1
fi

for f in "${files[@]}"; do
  name="$(basename "${f%.svg}")"
  out="$DEST_DIR/$name.png"
  echo "Converting: $(basename "$f") -> $(basename "$out")"
  magick -background none "$f" "$out"
done

echo "Done! Converted ${#files[@]} SVG file(s) to PNG in $DEST_DIR"
