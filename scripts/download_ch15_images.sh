#!/usr/bin/env bash
# Download images for Chapter 15: Reconstruction
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch15_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch15"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 15 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["reconstruction-congress.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_first_colored_senator_and_representatives_-_in_the_41st_and_42nd_Congress_of_the_United_States_LCCN98501907.jpg?width=640"
  ["freedmens-bureau.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_Freedmen%27s_Bureau_-_Drawn_by_A.R._Waud._LCCN92514996.jpg?width=640"
  ["kkk-cartoon.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Worse_than_Slavery_%281874%29%2C_by_Thomas_Nast.jpg?width=640"
  ["fifteenth-amendment.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/15th-amendment-celebration-1870.jpg?width=640"
  ["contrabands.jpg"]="https://cdn.loc.gov/service/pnp/cwpb/01000/01005r.jpg"
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
