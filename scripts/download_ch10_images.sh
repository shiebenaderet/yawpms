#!/usr/bin/env bash
# Download images for Chapter 10: Religion and Reform
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch10_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch10"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 10 images to $IMG_DIR ..."

declare -A IMAGES=(
  # "Underground Routes to Canada", Wilbur H. Siebert (1866-1961), 1898, from
  # "The Underground Railroad from Slavery to Freedom". Public domain.
  ["ugrr-siebert-1898.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/%22Underground%22_routes_to_Canada_(Siebert_1898).png?width=960"
  ["camp-meeting-revival.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Camp_meeting_of_the_Methodists_in_N._America_J._Milbert_del_M._Dubourg_sculp_(cropped).jpg?width=640"
  ["frederick-douglass.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Frederick_Douglass_%28circa_1879%29.jpg?width=440"
  ["seneca-falls.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Woman%27s_Rights_Convention.jpg?width=640"
  # Sojourner Truth, c.1870. Public domain. Aspect matches the local file (0.7154/0.7153).
  # Old URL was an upload.wikimedia.org thumb path that 400d.
  ["sojourner-truth.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Sojourner_truth_c1870.jpg?width=440"
  # Dorothea Dix, half-plate daguerreotype, c.1849, unidentified photographer. National
  # Portrait Gallery, Smithsonian Institution. Public domain.
  # Replaced 2026-09-11: the previous file was a vignetted copy print credited to the Library
  # of Congress, but its URL 400d and no matching LOC item could be found (searched LOC
  # Prints & Photographs, which returned only Dix letters). This portrait is sourced, and
  # better: the quill and papers are the point of her career.
  ["dorothea-dix.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Dorothea_Dix_1802%E2%80%931887.jpg?width=520"

  # Maps
  ["underground-railroad-map.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Undergroundrailroadsmall2.jpg?width=800"
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
