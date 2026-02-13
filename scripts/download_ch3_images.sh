#!/usr/bin/env bash
# Download images for Chapter 3: British North America
# Images sourced from The American Yawp (CC BY-SA 4.0) and Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch3_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch3"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 3 images to $IMG_DIR ..."

declare -A IMAGES=(
  # From Wikimedia Commons (public domain)
  ["pocahontas.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Pocahontas_by_Simon_van_de_Passe_1616.jpg/440px-Pocahontas_by_Simon_van_de_Passe_1616.jpg"
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
