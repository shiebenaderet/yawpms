#!/usr/bin/env bash
# Download images for Chapter 4: Colonial Society
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch4_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch4"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 4 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["rice-cultivation.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Rice_culture_on_the_Ogeechee%2C_near_Savannah%2C_Georgia_-_Sketched_by_A.R._Waud._LCCN2015647678.jpg?width=640"
  ["whitefield-preaching.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/George_Whitefield_preaching.jpg?width=640"
  ["join-or-die.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Benjamin_Franklin_-_Join_or_Die.jpg?width=640"
  ["peale-family.jpg"]="https://upload.wikimedia.org/wikipedia/commons/1/1c/The_Peale_Family.jpeg"
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
