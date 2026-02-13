#!/usr/bin/env bash
# Download images for Chapter 11: The Cotton Revolution
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch11_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch11"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 11 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["cotton-gin.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Eli_Whitney%27s_Cotton_Gin_Patent_Drawing%2C_03-14-1794%2C_Page_1_%285476286235%29.jpg?width=640"
  ["slave-family.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Family_of_slaves_at_the_Gaines%27_house_LCCN96511694.jpg?width=640"
  ["slave-auction.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Sale_of_estates%2C_pictures_and_slaves_in_the_rotunda%2C_New_Orleans.jpg?width=640"
  ["slave-population-map.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Slave_population_map_1860.jpg?width=640"
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
