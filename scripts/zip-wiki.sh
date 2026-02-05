#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
wiki_dir="$root_dir/wiki"
release_dir="$root_dir/release"

if [[ ! -d "$wiki_dir" ]]; then
  echo "wiki directory not found: $wiki_dir" >&2
  exit 1
fi

mkdir -p "$release_dir"

shopt -s nullglob
found=0
for dir in "$wiki_dir"/*/; do
  found=1
  name="$(basename "${dir%/}")"
  zip_path="$release_dir/wiki-${name}.zip"
  rm -f "$zip_path"
  (cd "$wiki_dir" && zip -r "$zip_path" "$name" >/dev/null)
  echo "wrote $zip_path"
done

if [[ $found -eq 0 ]]; then
  echo "no subfolders found in $wiki_dir" >&2
  exit 1
fi
