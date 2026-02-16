#!/usr/bin/env bash
# Download images for Chapter 13: The Sectional Crisis
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch13_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch13"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 13 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["john-brown.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/John_Brown_daguerreotype%2C_c._1856.png?width=440"
  ["dred-scott.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Oil_on_Canvas_Portrait_of_Dred_Scott_%28cropped%29.jpg?width=440"
  ["uncle-toms-cabin.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Uncle_Tom%27s_Cabin_cover.jpg?width=440"
  ["reynolds-political-map.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Reynolds%27s_Political_Map_of_the_United_States_1856.jpg?width=640"

  # Maps
  ["compromise-1850-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Compromise_of_1850.png?width=800"
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
