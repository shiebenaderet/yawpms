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
  ["first-locomotive.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_First_locomotive._Aug._8th%2C_1829._Trial_trip_of_the_%22Stourbridge_Lion%22_LCCN93517692.jpg?width=640"
  ["lowell-mills.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Lowell_Massachusetts_Merrimack_Mills.jpg?width=640"
  ["south-street-nyc.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/William_James_Bennett_-_View_of_South_Street%2C_from_Maiden_Lane%2C_New_York_City_-_Google_Art_Project.jpg?width=640"
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
