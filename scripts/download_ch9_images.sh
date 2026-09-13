#!/usr/bin/env bash
# Download images for Chapter 9: Democracy in America
# All five entries are public domain; verify per entry before reusing (bash scripts/audit_prep.sh 9).
#
# THERE IS DELIBERATELY NO DEPICTION OF THE MARCH ITSELF. Robert Ottokar Lindneux's painting
# "The Trail of Tears" (1942) is still under copyright and cannot be hosted on Commons, so an
# earlier pass substituted a public-domain route map as a fallback -- and the chapter caption
# went on naming Lindneux over it, describing a painting nobody could see, until 2026-09-13.
# That duplicate file (trail-of-tears.jpg, byte-identical to trail-of-tears-map.png) is gone.
# If you want a depiction here, source one that is actually free; do not re-add a caption for
# a picture the repo does not have.
#
# Usage: bash scripts/download_ch9_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch9"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 9 images to $IMG_DIR ..."

declare -A IMAGES=(
  # Ralph Eleaser Whiteside Earl, portrait of Andrew Jackson, between 1836 and 1837. Public
  # domain. The chapter caption credited Thomas Sully until 2026-09-13; both this entry's
  # filename and the Commons record say Earl.
  ["andrew-jackson.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Andrew_Jackson_by_Ralph_Eleaser_Whiteside_Earl.jpg?width=640"

  # George Caleb Bingham, "The County Election", 1852. Public domain. Bingham painted more
  # than one version of this subject; the Commons record for THIS file gives 1852, and the
  # chapter caption was corrected from 1854 to match on 2026-09-13.
  ["county-election.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/George_Caleb_Bingham_-_The_County_Election.jpg?width=640"

  # Maps
  # MODERN National Park Service map of the Trail of Tears National Historic Trail. Its legend
  # names the trail and it labels Oklahoma, a state that did not exist until 1907. Public
  # domain (US Govt work). The caption must not imply a period document.
  # CORRECTED 2026-09-13: this entry named Trails_of_Tears_en.png -- the Nikater map below --
  # so a fresh checkout would have silently overwritten the NPS map with the wrong picture.
  # Identified by aspect ratio: the local file and File:Trail of tears map NPS.jpg are both
  # 902x443 = 2.0361.
  ["trail-of-tears-map.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Trail_of_tears_map_NPS.jpg?width=960"

  # Nikater, "Indian Removal", 2007: removal routes of the five nations. Public domain.
  # Also carries the chapter title-page background since 2026-09-13.
  ["trail-of-tears-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Trails_of_Tears_en.png?width=800"

  ["indian-cessions-map.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Map_from_Indian_land_cessions_in_the_United_States_by_Charles_C._Royce_11.jpg?width=800"
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
