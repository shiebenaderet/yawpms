#!/usr/bin/env bash
# Download images for Chapter 4: Colonial Society
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch4_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch4"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 4 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["rice-cultivation.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Rice_culture_on_the_Ogeechee%2C_near_Savannah%2C_Georgia_-_Sketched_by_A.R._Waud._LCCN2015647678.jpg?width=640"
)

for local in "${!IMAGES[@]}"; do
  url="${IMAGES[$local]}"
  dest="$IMG_DIR/$local"
  if [ -f "$dest" ]; then
    echo "  [skip] $local already exists"
  else
    echo "  [download] $local"
    if curl -sL --fail "$url" -o "$dest" 2>/dev/null; then
      echo "  [ok] $local"
    else
      echo "  [FAILED] $local — check URL: $url"
      rm -f "$dest"
    fi
  fi
done

echo ""
echo "Done. Images saved to $IMG_DIR"
ls -la "$IMG_DIR"
