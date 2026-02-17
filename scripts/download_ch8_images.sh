#!/usr/bin/env bash
# Download images for Chapter 8: The Market Revolution
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch8_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch8"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 8 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["erie-canal.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Erie_Canal.jpg?width=640"
  ["first-locomotive.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_First_Locomotive._Aug._8th%2C_1829._Horatio_Allen%2C_engineer_LCCN2003680013.jpg?width=640"
  ["lowell-mills.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Lowell_Massachusetts_Merrimack_Mills.jpg?width=640"
  ["south-street-nyc.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/William_James_Bennett_-_View_of_South_Street%2C_from_Maiden_Lane%2C_New_York_City_-_Google_Art_Project.jpg?width=640"

  # Maps
  ["erie-canal-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Erie_Canal_map.png?width=800"
  ["railroads-1860-map.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Railroad_map_of_the_United_States_1861.jpg?width=800"
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
