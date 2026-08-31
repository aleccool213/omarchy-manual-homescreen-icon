#!/usr/bin/env bash
# Recreate generated/*.png from the committed base64 sidecars.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/generated"
for f in apple-touch-icon icon-192 icon-512 icon-maskable-512 preview-1024 mark-transparent-1200; do
  base64 -d "$ROOT/generated-b64/${f}.png.b64" > "$ROOT/generated/${f}.png"
done
ls -l "$ROOT/generated"
