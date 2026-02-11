#!/bin/bash
set -euo pipefail

# Full icon pipeline:
# 1) SVG -> high-res PNG
# 2) Resize high-res PNG into 150px, 40px, and 20px outputs

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "Step 1/4: Converting SVG to high-res PNG"
bash scripts/convert-svg-to-png.sh "${1:-}"

echo "Step 2/4: Generating 150px icons"
bash scripts/resize-150px.sh

echo "Step 3/4: Generating 40px icons"
bash scripts/resize-40px.sh

echo "Step 4/4: Generating 20px icons"
bash scripts/resize-20px.sh

echo "Done! Generated high-res, 150px, 40px, and 20px icon sets."
