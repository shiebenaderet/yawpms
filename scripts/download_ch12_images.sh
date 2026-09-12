#!/usr/bin/env bash
# Download images for Chapter 12: Manifest Destiny
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch12_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch12"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 12 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["american-progress.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/American_Progress_%28John_Gast_painting%29.jpg?width=640"
  ["oregon-trail.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Bierstadt_Albert_Oregon_Trail.jpg?width=640"
  # Battle of Chapultepec, 1851 lithograph. Public domain. The Commons file is 640x403 --
  # exactly the local dimensions. Old URL was a thumb path that 400d.
  ["battle-of-chapultepec.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Battle_of_Chapultepec.jpg"
  # California gold miners with a long tom, c.1850-52. Daguerreotype by George H. Johnson,
  # Nelson-Atkins Museum of Art. Public domain. Commons file is 1000x772 = 1.2953 against the
  # local 1.2955. Old URL was a thumb path that 400d.
  ["gold-rush-miners.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/California_gold_miners_with_long_tom.jpg?width=960"
  # The Mexican Cession. A MODERN map (2008) by Commons user Kballen.
  # *** CC BY 3.0 -- ATTRIBUTION REQUIRED ***, now named in the caption, which carried no
  # credit at all until 2026-09-11. Old URL was a thumb path that 400d.
  ["mexican-cession-map.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Mexican_Cession.png?width=960"

  # Maps
  ["oregon-territory-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Oregon_Territory_1848.svg?width=600"
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
