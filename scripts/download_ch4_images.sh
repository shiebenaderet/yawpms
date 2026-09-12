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
  # "The Peale Family" by Charles Willson Peale, begun c.1773, finished 1809. Public domain.
  # The Google Art Project title in the old URL does not exist on Commons.
  ["peale-family.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_peale_family_charles_willson_peale.jpg?width=750"

  # Maps
  ["triangular-trade-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Triangle_trade2.png?width=800"
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
