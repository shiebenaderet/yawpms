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
  ["common-sense.jpg"]="https://upload.wikimedia.org/wikipedia/commons/4/4a/Commonsense.jpg"
  ["declaration-of-independence.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Declaration_of_Independence_%281819%29%2C_by_John_Trumbull.jpg?width=640"
  ["surrender-cornwallis.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Surrender_of_Lord_Cornwallis.jpg?width=640"
  ["yorktown-soldiers.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/Soldats_de_l%27Arm%C3%A9e_Continentale_%C3%A0_Yorktown.jpg/640px-Soldats_de_l%27Arm%C3%A9e_Continentale_%C3%A0_Yorktown.jpg"
)

MIN_SIZE=5000
for local in "${!IMAGES[@]}"; do
  url="${IMAGES[$local]}"
  dest="$IMG_DIR/$local"
  if [ -f "$dest" ] && [ "$(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null)" -ge "$MIN_SIZE" ]; then
    echo "  [skip] $local"
  else
    echo "  [download] $local"
    sleep 2
    if ! curl -sL --fail --max-time 60 -A "$CURL_USER_AGENT" "$url" -o "$dest" 2>/dev/null; then
      echo "  [retry in 5s] $local"
      sleep 5
      curl -sL --fail --max-time 60 -A "$CURL_USER_AGENT" "$url" -o "$dest" 2>/dev/null || true
    fi
    if [ -f "$dest" ]; then
      size=$(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null)
      if [ "${size:-0}" -lt "$MIN_SIZE" ]; then
        echo "  [FAILED] $local — got ${size:-0} bytes (likely error page)"
        rm -f "$dest"
      else
        echo "  [ok] $local"
      fi
    else
      echo "  [FAILED] $local — check URL"
    fi
  fi
done

echo ""
echo "Done. Images saved to $IMG_DIR"
ls -la "$IMG_DIR"
