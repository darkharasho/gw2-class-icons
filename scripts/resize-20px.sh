#!/bin/bash

# Resize all images from wiki/high-res/ to wiki/20px/
# Images are scaled so the larger dimension is 20px while maintaining aspect ratio

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

SRC_DIR="$PROJECT_DIR/wiki/high-res"
DEST_DIR="$PROJECT_DIR/wiki/20px"

mkdir -p "$DEST_DIR"

for f in "$SRC_DIR"/*.png; do
  name=$(basename "$f")
  echo "Resizing: $name"
  magick "$f" -resize '20x20>' "$DEST_DIR/$name"
done

echo "Done! Resized images are in $DEST_DIR"
