#!/usr/bin/env bash
# Download images for Chapter 12: Manifest Destiny
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch12_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch12"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 12 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["american-progress.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/American_Progress_%28John_Gast_painting%29.jpg?width=640"
  ["oregon-trail.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Bierstadt_Albert_Oregon_Trail.jpg?width=640"
  ["battle-of-chapultepec.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Battle_of_Chapultepec.jpg?width=640"
  ["gold-rush-miners.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/California_gold_miners_with_long_tom.jpg?width=640"
  ["mexican-cession-map.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Mexican_Cession.png?width=640"
)

MIN_SIZE=5000
for local in "${!IMAGES[@]}"; do
  url="${IMAGES[$local]}"
  dest="$IMG_DIR/$local"
  if [ -f "$dest" ] && [ "$(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null)" -ge "$MIN_SIZE" ]; then
    echo "  [skip] $local already exists"
  else
    echo "  [download] $local"
    sleep 2
    if ! curl -sL --fail --max-time 60 "$url" -o "$dest" 2>/dev/null; then
      echo "  [retry in 5s] $local"
      sleep 5
      curl -sL --fail --max-time 60 "$url" -o "$dest" 2>/dev/null || true
    fi
    if [ -f "$dest" ]; then
      size=$(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null)
      if [ "${size:-0}" -lt "$MIN_SIZE" ]; then
        echo "  [FAILED] $local — got ${size:-0} bytes (likely error page)"
        rm -f "$dest"
      else
        echo "  [ok] $local"
      fi
    else
      echo "  [FAILED] $local — check URL"
    fi
  fi
done

echo ""
echo "Done. Images saved to $IMG_DIR"
ls -la "$IMG_DIR"
