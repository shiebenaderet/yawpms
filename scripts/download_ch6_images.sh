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
  # "The Federal Edifice" / "On the erection of the Eleventh PILLAR", Massachusetts Centinel,
  # 2 August 1788. The artefact self-identifies: its own title, motto (REDEUNT SATURNIA REGNA)
  # and eleven labelled pillars are legible in the file. Public domain by date (1788).
  # DIGITAL SOURCE NOT ESTABLISHED. The old URL pointed at File:Eleventh_Pillar.jpg, which has
  # NO Commons log entry at all -- it was never uploaded, not deleted. Absent from Commons,
  # LOC search and the obvious Wikipedia articles (checked 2026-09-11). The caption previously
  # credited "Library of Congress"; that claim is unverified and has been removed.
  ["federal-pillars.jpg"]="UNKNOWN"
  # Shays and Shattuck from Bickerstaff's Boston Almanack, 1787; relief cut, unidentified
  # artist. National Portrait Gallery via Google Art Project. Public domain. Verified
  # 2026-09-11 by comparing the local file against the Commons original (same tears, verse
  # and show-through; local is a clean 3.22x downscale of 5155x3385).
  # The old URL was an upload.wikimedia.org THUMB path that 400d -- and it named
  # File:Shays' Rebellion.jpg, which is a DIFFERENT image: a 2017 CC BY-SA 4.0 drawing by
  # "Wmpetro". Had it resolved it would have fetched the wrong picture. Do not substitute it.
  ["shays-shattuck.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Unidentified_Artist_-_Daniel_Shays_and_Job_Shattuck_-_Google_Art_Project.jpg?width=1600"
  # Assembly Room, Independence Hall. Photograph by Antoine Taveneaux, 3 June 2011.
  # *** CC BY-SA 3.0 -- ATTRIBUTION REQUIRED, and it is a MODERN photograph.
  # The Assembly Room, Independence Hall. A PRESENT-DAY PHOTOGRAPH (3 June 2011) by Antoine
  # Taveneaux -- CC BY-SA 3.0, *** ATTRIBUTION REQUIRED ***, which the caption carries.
  # Not a historical image; the caption says 'photographed in 2011'. Also the chapter's
  # title-page background, so keep it large. Old URL was a thumb path that 400d.
  ["independence-hall.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Independence_Hall_10.jpg?width=1600"
  # James Madison by John Vanderlyn, 1816. Public domain. The local file had been a 16:9
  # banner CROP of this painting from an unrecorded source; replaced 2026-09-11 with the
  # full portrait from Commons. Old URL was a thumb path that 404d.
  ["madison.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/James_Madison.jpg?width=900"
  ["hamilton.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Alexander_Hamilton_portrait_by_John_Trumbull_1806.jpg/500px-Alexander_Hamilton_portrait_by_John_Trumbull_1806.jpg"
  # Execution of Louis XVI, 21 January 1793. Engraving by Isidore Stanislas Helman after
  # Charles Monnet, 1794. Public domain. Old URL was a thumb path that 400d.
  ["execution-louis-xvi.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Execution_of_Louis_XVI.jpg?width=1600"
  # "The Providential Detection", c.1797-1800: Jefferson kneeling at an "Altar to Gallic
  # Despotism", his letter "To Mazzei" in hand, the eagle seizing the Constitution. The
  # artefact self-identifies -- the title is engraved along the bottom. Public domain by date.
  # DIGITAL SOURCE NOT ESTABLISHED. The old URL pointed at File:Jefferson-LOC.jpg, which has no
  # Commons log entry -- never uploaded. The best-known impression is at the American
  # Antiquarian Society, but that THIS scan is theirs is unverified, so the caption no longer
  # asserts it.
  ["anti-jefferson-cartoon.jpeg"]="UNKNOWN"
  # The US Capitol c.1800, by William Russell Birch. Public domain.
  # Old URL was a thumb path that 400d.
  ["us-capitol-1800.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/USCapitol1800.jpg?width=1600"
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
