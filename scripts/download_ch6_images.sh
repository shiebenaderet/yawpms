#!/usr/bin/env bash
# Download images for Chapter 6: A New Nation
# Image sources and licences VARY BY FIGURE; each entry below records its own.
# Do NOT assume public domain. Two figures here are CC BY / CC BY-SA and require
# named attribution in the caption: us-territory-1789-map.png (Golbez, CC BY 2.5)
# and independence-hall.jpg (Antoine Taveneaux, CC BY-SA 3.0).
# Usage: bash scripts/download_ch6_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch6"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 6 images to $IMG_DIR ..."

declare -A IMAGES=(
  # "The Federal Edifice" woodcut, Massachusetts Centinel, Boston, 2 August 1788.
  # Celebrates the ELEVENTH pillar -- New York, which ratified 26 July 1788 -- hence the
  # Commons filename. N. Carolina is shown being raised, Rhode Island broken. Public domain.
  # Library of Congress, Serial and Government Publications Division. Evans 30323.
  # NOTE: the caption said 1789 until 2026-09-09; a print dated 1789 would be news of nothing.
  ["federal-pillars.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Eleventh_Pillar.jpg/600px-Eleventh_Pillar.jpg"
  ["shays-shattuck.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Shays%27_Rebellion.jpg/600px-Shays%27_Rebellion.jpg"
  # Assembly Room, Independence Hall. Photograph by Antoine Taveneaux, 3 June 2011.
  # *** CC BY-SA 3.0 -- ATTRIBUTION REQUIRED, and it is a MODERN photograph.
  ["independence-hall.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Independence_Hall_10.jpg/800px-Independence_Hall_10.jpg"
  ["madison.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/James_Madison.jpg/500px-James_Madison.jpg"
  ["hamilton.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Alexander_Hamilton_portrait_by_John_Trumbull_1806.jpg/500px-Alexander_Hamilton_portrait_by_John_Trumbull_1806.jpg"
  ["execution-louis-xvi.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Execution_of_Louis_XVI.jpg/800px-Execution_of_Louis_XVI.jpg"
  ["anti-jefferson-cartoon.jpeg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Jefferson-LOC.jpg/500px-Jefferson-LOC.jpg"
  ["us-capitol-1800.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/USCapitol1800.jpg/800px-USCapitol1800.jpg"
  # US states and territories, Aug 1789 - 1790. Made by Wikimedia user Golbez.
  # *** CC BY 2.5 -- ATTRIBUTION REQUIRED. Not public domain. Both figcaptions in ch6
  # *** must name Golbez; they claimed "public domain" until 2026-09-09.
  # Used TWICE in ch6 (sections I and IV).
  ["us-territory-1789-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/United_States_1789-08-1790.png?width=800"
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
echo "Note: us-territory-1789.png (map) is provided by scripts/download_all_maps.sh"
ls -la "$IMG_DIR"
