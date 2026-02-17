#!/usr/bin/env bash
# Download images for Chapter 5: The American Revolution
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch5_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch5"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 5 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["boston-massacre.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Boston_Massacre_high-res.jpg?width=640"
  ["common-sense.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Common_Sense_by_Thomas_Paine.jpg?width=440"
  ["declaration-of-independence.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Declaration_of_Independence_%281819%29%2C_by_John_Trumbull.jpg?width=640"
  ["surrender-cornwallis.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Surrender_of_Lord_Cornwallis.jpg?width=640"
  ["yorktown-soldiers.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Soldats_de_l%27Arm%C3%A9e_Continentale_%C3%A0_Yorktown.jpg?width=640"

  # Maps
  ["revolution-battles-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/American_Revolutionary_War_battles_map.svg?width=600"
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
