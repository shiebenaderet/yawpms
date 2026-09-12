#!/usr/bin/env bash
# Download images for Chapter 3: British North America
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch3_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch3"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 3 images to $IMG_DIR ..."

declare -A IMAGES=(
  # Jamestown 1607 -- archaeologists excavating a double burial at James Fort.
  # Smithsonian Institution, via newsdesk.si.edu. Modern photograph.
  # *** CC BY-SA 3.0 -- ATTRIBUTION REQUIRED. This is the only non-public-domain
  # *** image in the repo. The caption MUST name the Smithsonian Institution and
  # *** MUST NOT say "public domain". timeline.html carries it in a credit: field.
  # Remains are European colonists', so no NAGPRA / Indigenous-remains concern.
  ["jamestown-burial.jpg"]="https://upload.wikimedia.org/wikipedia/commons/7/70/Jamestown_excavation.jpg"

  # Bacon's Rebellion (1676) -- "The Burning of Jamestown", engraving signed
  # "F.A.C." for Whitney-Jocelyn, N.Y., 1857. Public domain.
  # NOTE: retrospective (1857 engraving of a 1676 event); caption says so.
  # Serves timeline.html's 1676 entry ONLY -- not the 1607 founding.
  ["burning-of-jamestown.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_Burning_of_Jamestown.jpg?width=1400"

  ["pocahontas.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Pocahontas_by_Simon_van_de_Passe.jpg?width=640"
  ["mayflower-compact.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_Mayflower_Compact_1620_cph.3g07155.jpg?width=640"
  ["slave-ship-brookes.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Slaveshipposter.jpg?width=640"
  # "The Old Plantation", watercolour attributed to John Rose, c.1785-1795 (Abby Aldrich
  # Rockefeller Folk Art Museum). Public domain. Aspect matches the local file exactly.
  ["old-plantation.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/SlaveDanceand_MusicFXD.jpg?width=960"

  # Maps
  # The Thirteen Colonies in 1775. A MODERN map (2007, Commons user "Urban"), public domain.
  # Replaced 2026-09-11: the previous file was an unsourced modern line map whose URL 404d.
  # A modern map's licence cannot be assumed safe from its age the way a 1788 print's can,
  # so an unsourced one is a real licensing risk, not just an unverifiable credit.
  ["thirteen-colonies-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Map_Thirteen_Colonies_1775.svg?width=900"
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
