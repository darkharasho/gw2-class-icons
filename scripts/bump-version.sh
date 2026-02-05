#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root_dir"

files=()
while IFS= read -r file; do
  files+=("$file")
done < <(rg -l -F "?v=" .)

if [[ ${#files[@]} -eq 0 ]]; then
  echo "no files found with ?v=" >&2
  exit 1
fi

new_version="${1-}"
if [[ -z "$new_version" ]]; then
  today="$(date +%Y%m%d)"
  max_suffix=0
  while IFS= read -r version; do
    if [[ "$version" == "$today-"* ]]; then
      suffix="${version#*-}"
      if [[ "$suffix" =~ ^[0-9]+$ ]] && (( suffix > max_suffix )); then
        max_suffix="$suffix"
      fi
    fi
  done < <(rg -o -N "\\?v=20260205-1)" -r '$1' "${files[@]}" | sort -u)

  if (( max_suffix > 0 )); then
    new_version="$today-$((max_suffix + 1))"
  else
    new_version="$today-1"
  fi
fi

for file in "${files[@]}"; do
  perl -pi -e "s/\\?v=20260205-1)\"']+/?v=20260205-1" "$file"
done

echo "bumped ?v= to ${new_version} in ${#files[@]} file(s)"
