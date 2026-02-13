#!/usr/bin/env bash
# Download images for Chapter 15: Reconstruction
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch15_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch15"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 15 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["reconstruction-congress.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_first_colored_senator_and_representatives_-_in_the_41st_and_42nd_Congress_of_the_United_States_LCCN98501907.jpg?width=640"
  ["freedmens-bureau.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_Freedmen%27s_Bureau_-_Drawn_by_A.R._Waud._LCCN92514996.jpg?width=640"
  ["kkk-cartoon.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Worse_than_Slavery_%281874%29%2C_by_Thomas_Nast.jpg?width=640"
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
