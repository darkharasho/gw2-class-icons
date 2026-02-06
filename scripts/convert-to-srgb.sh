#!/bin/bash

# Replace CMYK black (#0e0e0b) with true RGB black (#000000)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

WIKI_DIR="$PROJECT_DIR/wiki"

find "$WIKI_DIR" -name "*.png" -print0 | while IFS= read -r -d '' f; do
  echo "Converting: $f"
  magick "$f" -fill "#000000" -opaque "#0e0e0b" "$f"
done

echo "Done! All #0e0e0b converted to #000000"
