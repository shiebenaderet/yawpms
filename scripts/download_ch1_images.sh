#!/usr/bin/env bash
# Download images for Chapter 1: Indigenous America
# Images sourced from Wikimedia Commons (public domain / CC BY-SA)
# Usage: bash scripts/download_ch1_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch1"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 1 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["cahokia-mounds.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Cahokia_Aerial_HRoe_2015.jpg?width=640"
  ["mesa-verde.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Cliff_Palace_Mesa_Verde_National_Park_Colorado_USA.JPG?width=640"
  ["tenochtitlan.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_Great_Tenochtitlan_full_view.JPG?width=640"
  ["casta-painting.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Casta_painting_all.jpg?width=640"
  ["crooked-beak-mask.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Crooked_Beak_of_Heaven_Mask.jpg?width=640"
)

MIN_SIZE=5000
for local in "${!IMAGES[@]}"; do
  url="${IMAGES[$local]}"
  dest="$IMG_DIR/$local"
  if [ -f "$dest" ] && [ "$(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null)" -ge "$MIN_SIZE" ]; then
    echo "  [skip] $local already exists"
  else
    echo "  [download] $local"
    if curl -sL --fail "$url" -o "$dest" 2>/dev/null; then
      size=$(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null)
      if [ "$size" -lt "$MIN_SIZE" ]; then
        echo "  [FAILED] $local — got $size bytes (likely error page)"
        rm -f "$dest"
      else
        echo "  [ok] $local"
      fi
    else
      echo "  [FAILED] $local — check URL: $url"
      rm -f "$dest"
    fi
  fi
done

echo ""
echo "Done. Images saved to $IMG_DIR"
ls -la "$IMG_DIR"
