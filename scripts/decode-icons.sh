#!/usr/bin/env bash
# Recreate generated/*.png from the committed base64 sidecars.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/generated"
count=0
for f in apple-touch-icon icon-192 icon-512 icon-maskable-512 preview-1024 mark-transparent-1200; do
  src="$ROOT/generated-b64/${f}.png.b64"
  if [[ -f "$src" ]]; then
    base64 -d "$src" > "$ROOT/generated/${f}.png"
    count=$((count+1))
  fi
done
echo "decoded $count PNG(s) into $ROOT/generated"
ls -l "$ROOT/generated" || true
