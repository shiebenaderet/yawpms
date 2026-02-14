#!/usr/bin/env bash
# Download images for Chapter 3: British North America
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch3_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch3"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 3 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["pocahontas.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Pocahontas_by_Simon_van_de_Passe.jpg?width=640"
  ["mayflower-compact.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/The_Mayflower_Compact_1620_cph.3g07155.jpg/960px-The_Mayflower_Compact_1620_cph.3g07155.jpg"
  ["slave-ship-brookes.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Slaveshipposter.jpg?width=640"
  ["old-plantation.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/SlaveDanceand_Music.jpg?width=640"
  ["virginia-fishing.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_Carte_of_all_the_Coast_of_Virginia_by_Theodor_de_Bry_1585_1586.jpg?width=640"
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
