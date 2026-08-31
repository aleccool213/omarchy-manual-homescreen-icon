#!/usr/bin/env bash
# Rebuild generated/*.png from the official Omarchy mark.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/upstream/icon.svg"
OUT="$ROOT/generated"
BG="#1a1b26"

if ! command -v convert >/dev/null 2>&1; then
  echo "ImageMagick 'convert' is required" >&2
  exit 1
fi

mkdir -p "$OUT"

convert -background none "$SRC" -resize 1200x1200 PNG32:"$OUT/mark-transparent-1200.png"

render () {
  local size="$1" mark="$2" dest="$3"
  convert -size "${size}x${size}" "xc:${BG}" \
    \( "$OUT/mark-transparent-1200.png" -resize "${mark}x${mark}" \) \
    -gravity center -compose over -composite -alpha off -strip -depth 8 \
    PNG32:"$dest"
}

# ~20% padding so iOS rounded-square / glass treatment does not clip strokes
render 180 108 "$OUT/apple-touch-icon.png"
render 192 116 "$OUT/icon-192.png"
render 512 308 "$OUT/icon-512.png"
render 512 280 "$OUT/icon-maskable-512.png"
render 1024 620 "$OUT/preview-1024.png"

echo "wrote:"
ls -l "$OUT"/*.png
