#!/usr/bin/env bash
# Download images for Chapter 2: Colliding Cultures
# Images sourced from The American Yawp (CC BY-SA 4.0) and Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch2_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch2"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 2 images to $IMG_DIR ..."

declare -A IMAGES=(
  # From Wikimedia Commons (public domain)
  ["champlain-habitation.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Habitation_de_Quebec.jpg/640px-Habitation_de_Quebec.jpg"
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
