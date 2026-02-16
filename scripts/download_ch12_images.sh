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
  ["battle-of-chapultepec.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Battle_of_Chapultepec.jpg/640px-Battle_of_Chapultepec.jpg"
  ["gold-rush-miners.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/California_gold_rush_daguerreotype.jpg/640px-California_gold_rush_daguerreotype.jpg"
  ["mexican-cession-map.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Mexican_Cession.png/640px-Mexican_Cession.png"

  # Maps
  ["oregon-territory-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Oregon_territory_1848.svg?width=600"
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
