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
  # Jim Crow -- "Colored Waiting Room", Durham NC bus station. Jack Delano,
  # May 1940. Public domain (US Farm Security Administration / OWI collection).
  # Library of Congress, digital ID fsa.8a33837.
  # NOTE: 1940 photograph illustrating a post-1877 system; the caption dates it.
  ["reconstruction-ends.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/JimCrowInDurhamNC.jpg?width=1400"

  ["reconstruction-congress.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_first_colored_senator_and_representatives_-_in_the_41st_and_42nd_Congress_of_the_United_States_LCCN98501907.jpg?width=640"
  ["freedmens-bureau.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_Freedmen%27s_Bureau_-_Drawn_by_A.R._Waud._LCCN92514996.jpg?width=640"
  ["kkk-cartoon.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Worse_than_Slavery_%281874%29%2C_by_Thomas_Nast.jpg?width=640"
  ["fifteenth-amendment.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/15th-amendment-celebration-1870.jpg?width=640"
  # Cumberland Landing, Va., group of "contrabands" at Foller's house, May 1862. Photograph by
  # James F. Gibson; LOC Civil War Glass Negatives, cwpb.01005. Public domain.
  # The old URL named cwpb.00101 with %22 quotes; the real file is cwpb.01005 with straight
  # quotes, so it 404d. The local file was a looser crop showing the glass-plate borders and
  # was replaced 2026-09-11 with the Commons image so the manifest reproduces it exactly.
  ["contrabands.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Cumberland_Landing,_Va._Group_of_'contrabands'_at_Foller's_house_LOC_cwpb.01005.jpg?width=800"

  # Maps
  ["reconstruction-districts-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Reconstruction_military_districts.svg?width=600"
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
