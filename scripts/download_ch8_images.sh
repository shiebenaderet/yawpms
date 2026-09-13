#!/usr/bin/env bash
# Download images for Chapter 8: The Market Revolution
# NOT all public domain. Check each entry before reusing:
#   south-street-nyc.jpg released CC0 by the Metropolitan Museum of Art; the 1827 watercolor is
#                        also public domain by age
#   the other five       public domain (Library of Congress, NYPL, or by age)
# Check each entry before reusing -- this header used to assert "public domain" over every file,
# which is how a CC BY-SA photograph sat uncredited in the chapter until 2026-09-12.
# Usage: bash scripts/download_ch8_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch8"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 8 images to $IMG_DIR ..."

declare -A IMAGES=(
  # John William Hill, "View on the Erie Canal", watercolor, 1831 -- six years after the canal
  # opened. I.N. Phelps Stokes Collection, New York Public Library; no known restrictions.
  # Same work as primary-sources/images/ch8-erie-canal-1831.jpg (Source 8.4), fetched at a
  # larger width here for the chapter figure and the title-page background. 760x542 is the
  # source file's native resolution; ?width= above that returns the original.
  # REPLACED 2026-09-12 the file erie-canal.jpg, which was a 2016 CC BY-SA 4.0 photograph by
  # Randall Reese captioned "(Public domain, 19th century)" and credited to nobody, reused as
  # the chapter cover where a CSS background can carry no attribution at all.
  ["erie-canal-1831.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/(View_on_the_Erie_Canal.)_(3990756054).jpg?width=1200"
  # "The First locomotive. Aug. 8th, 1829. Trial trip of the Stourbridge Lion", painted by
  # Clyde Osmer DeLand in 1916 -- NOT contemporary; the caption now says so. LOC, public
  # domain. Aspect matches the local file (4096x3279 = 1.2492 vs 1.2484).
  # The old URL carried LCCN2003680013, which is a different LOC item entirely ("The
  # virgin's offering"). The correct number is LCCN93517692.
  ["first-locomotive.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_First_locomotive._Aug._8th,_1829._Trial_trip_of_the_%22Stourbridge_Lion%22_LCCN93517692.jpg?width=960"
  # "[Lowell, Mass., mills on Merrimack River]", Detroit Publishing Co., between 1900 and 1910.
  # Glass negative, LOC LC-D4-34904, digital id det.4a18323. Public domain.
  # A PHOTOGRAPH, and roughly 60 years later than the mill-girl era it illustrates -- the
  # caption says so. Its alt text called it "a plan" until 2026-09-12.
  ["lowell-mills.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Lowell%2C_Mass.%2C_mills_on_Merrimack_River%3B_LOC%3B_det.4a18323.jpg?width=640"
  # William James Bennett (American, London 1787-1844 New York), "View of South Street, from
  # Maiden Lane, New York City", ca. 1827. WATERCOLOR on off-white wove paper, 9 5/8 x 13 5/8 in.
  # Metropolitan Museum of Art 54.90.130, Edward W. C. Arnold Collection. Released CC0 by the Met;
  # the work is also public domain by age.
  ["south-street-nyc.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/View_of_South_Street%2C_from_Maiden_Lane%2C_New_York_City_MET_DT5570.jpg?width=640"

  # Maps
  # Map and profile of the Erie Canal, 1834, by Guillaume Tell Poussin. Public domain.
  # REPLACED 2026-09-11. The previous file was not a map at all: it was a modern colour
  # snapshot of a canal in autumn (metal railing, phone-camera framing), sitting inside a
  # map-figure with a "Map" badge and a caption describing a 363-mile route. Its URL 404d.
  ["erie-canal-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Map_and_profile_of_the_Erie_Canal,_1834_(cropped).jpg?width=960"
  # "Map of the canals & rail roads of the United States", H.S. Tanner, engraved by J.W.
  # Knight, 1840. Library of Congress; public domain. Aspect identifies the edition: the
  # local file is 1.3169, the 1840 plate 1.3163, the 1830 plate 1.3380.
  # The caption called this an 1861 RAILROAD map and drew a North/South Civil War contrast
  # from it. It is an 1840 canals-and-railroads map; that argument belongs in ch14 with a
  # map that supports it. Corrected 2026-09-11.
  ["railroads-1860-map.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Map_of_the_canals_%26_rail_roads_of_the_United_States,_reduced_from_the_large_map_of_the_U.S.;_engraved_by_J._Knight._LOC_98688305.jpg?width=960"
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
