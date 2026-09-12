#!/usr/bin/env bash
# Download images for Chapter 11: The Cotton Revolution
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch11_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch11"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 11 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["cotton-gin.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Eli_Whitney%27s_Cotton_Gin_Patent_Drawing%2C_03-14-1794%2C_Page_1_%285476286235%29.jpg?width=640"
  ["slave-family.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Family_of_slaves_at_the_Gaines%27_house_LCCN96511694.jpg?width=640"
  # "Sale of Estates, Pictures and Slaves in the Rotunda, New Orleans", 1842. Engraved by
  # J.M. Starling after William Henry Brooke. Public domain. The Commons file is 760x557 --
  # exactly the local dimensions. The old URL had commas in the title; the file has none.
  ["slave-auction.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Sale_of_Estates_Pictures_and_Slaves_in_the_Rotunda_New_Orleans.jpg"
  # US Coast Survey slave-population map, Washington, September 1861. Library of Congress
  # scan; public domain (US government work). Aspect matches the local file exactly
  # (10503x8380 = 1.2534 vs 1.2533), and the local file carries the LOC Map Division stamp.
  # NOT the NOAA scan on Commons, which is a different image tagged CC BY 2.0.
  ["slave-population-map.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Map_showing_the_distribution_of_the_slave_population_of_the_southern_states_of_the_United_States._Compiled_from_the_census_of_1860_LOC_99447026.jpg?width=960"

  # Maps
  ["domestic-slave-trade-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Map_of_slavery_and_slave_trade_in_the_United_States_1830%E2%80%931850_by_Albert_Bushnell_Hart_%281906%29.jpg?width=800"
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
