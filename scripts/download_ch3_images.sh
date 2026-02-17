#!/usr/bin/env bash
# Download images for Chapter 3: British North America
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch3_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch3"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 3 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["pocahontas.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Pocahontas_by_Simon_van_de_Passe.jpg?width=640"
  ["mayflower-compact.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_Mayflower_Compact_1620_cph.3g07155.jpg?width=640"
  ["slave-ship-brookes.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Slaveshipposter.jpg?width=640"
  ["old-plantation.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_Old_Plantation.jpg?width=640"

  # Maps
  ["thirteen-colonies-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Thirteen_Colonies_1775.svg?width=600"
)

for local in "${!IMAGES[@]}"; do
  url="${IMAGES[$local]}"
  dest="$IMG_DIR/$local"
  if [ -f "$dest" ]; then
    echo "  [skip] $local already exists"
  else
    echo "  [download] $local"
    if curl -sL --fail --max-time 60 -A "$CURL_USER_AGENT" "$url" -o "$dest" 2>/dev/null; then
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
