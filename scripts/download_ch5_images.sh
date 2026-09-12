#!/usr/bin/env bash
# Download images for Chapter 5: The American Revolution
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch5_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch5"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 5 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["boston-massacre.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Boston_Massacre_high-res.jpg?width=640"
  # Title page of Thomas Paine's Common Sense, 1776. Public domain.
  # Commons File:Commonsense.jpg is 510x800 -- exactly the local file's dimensions.
  ["common-sense.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Commonsense.jpg"
  ["declaration-of-independence.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Declaration_of_Independence_%281819%29%2C_by_John_Trumbull.jpg?width=640"
  ["surrender-cornwallis.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Surrender_of_Lord_Cornwallis.jpg?width=640"
  # DeVerger watercolor, 1781. Four soldiers at Yorktown. Public domain.
  # NOTE: the file committed to images/ch5 is .gif, not .jpg -- ch5.html references
  # yorktown-soldiers.gif. Keeping both names in step is why this entry exists.
  # American and French soldiers at the siege of Yorktown, watercolour by French officer
  # Jean-Baptiste-Antoine de Verger, 1781. Public domain. The leftmost figure is a soldier of
  # the 1st Rhode Island Regiment, which the caption points out. Verified 2026-09-11 against
  # the local file (four figures, same order).
  # NOTE: the Commons master is a .png while the local file is a genuine .gif, so re-running
  # this script writes PNG bytes to a .gif name. Harmless (browsers sniff content) but the
  # name is referenced by ch5.html, timeline.html and download_all_maps.sh, so it was not
  # renamed. The old URL used a French title that does not exist on Commons.
  ["yorktown-soldiers.gif"]="https://commons.wikimedia.org/wiki/Special:FilePath/Soldiers_at_the_siege_of_Yorktown_(1781),_by_Jean-Baptiste-Antoine_DeVerger.png?width=1100"

  # Siege of Yorktown, 6-20 October 1781. MODERN teaching map (US Military Academy
  # Department of History atlas, plate 42) -- uses NATO unit symbols, so it is not a
  # period document and the caption must not imply one. Public domain (US Govt work).
  # Siege of Yorktown, 6-20 October 1781. A MODERN teaching map by the U.S. Military Academy,
  # public domain (US government work); the caption says it is modern. The Commons file is
  # 736x911 -- byte-for-byte the dimensions of the local file.
  ["siege-of-yorktown.gif"]="https://commons.wikimedia.org/wiki/Special:FilePath/US_Army_52415_Siege_of_Yorktown_Map.gif"

  # Maps
  ["revolution-battles-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/American_Revolution_Campaigns_1775_to_1781.jpg?width=600"
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
