#!/usr/bin/env bash
# Download images for Chapter 9: Democracy in America
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch9_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch9"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 9 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["andrew-jackson.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Andrew_Jackson_by_Ralph_Eleaser_Whiteside_Earl.jpg?width=640"
  ["county-election.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/George_Caleb_Bingham_-_The_County_Election.jpg?width=640"
  # NOTE: The Lindneux "Trail of Tears" painting (1942) is under copyright.
  # Using the Robert Ottokar Lindneux painting via fair-use is not possible on Commons.
  # This URL points to a public-domain map of the Trail of Tears route as a fallback.
  ["trail-of-tears.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Trails_of_Tears_en.png?width=640"
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
