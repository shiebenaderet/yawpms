#!/usr/bin/env bash
# Download images for Chapter 5: The American Revolution
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch5_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch5"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 5 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["boston-massacre.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Boston_Massacre_high-res.jpg?width=640"
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
