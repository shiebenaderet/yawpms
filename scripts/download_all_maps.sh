#!/usr/bin/env bash
# Download all chapter maps in one script. Saves to images/ch1 .. images/ch15.
# Sources: Wikimedia Commons (PD/CC), LOC, NPS, NARA. See MAPS.md for plan.
# Usage: bash scripts/download_all_maps.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
W="https://commons.wikimedia.org/wiki/Special:FilePath"
# Use 960px for readability; fall back to 640px if a thumbnail is missing
SIZE="?width=960"
UPLOAD="https://upload.wikimedia.org/wikipedia/commons"

download() {
  local ch="$1"
  local file="$2"
  local url="$3"
  local dest="$BASE_DIR/images/ch${ch}/${file}"
  mkdir -p "$(dirname "$dest")"
  if [ -f "$dest" ]; then
    echo "  [skip] ch${ch}/${file}"
  else
    echo "  [get]  ch${ch}/${file}"
    if curl -sL --fail "$url" -o "$dest" 2>/dev/null; then
      echo "  [ok]   ch${ch}/${file}"
    else
      echo "  [FAIL] ch${ch}/${file}"
      rm -f "$dest"
    fi
  fi
}

echo "Downloading all maps to $BASE_DIR/images/chN/ ..."
echo ""

# Chapter 1 — Indigenous America
echo "Chapter 1 (Indigenous America)"
download 1 "native-cultural-regions.jpg" "${W}/National_atlas._Indian_tribes,_cultures_%26_languages_-_%28United_States%29_LOC_95682185.jpg${SIZE}"
download 1 "beringia-land-bridge.png"   "${W}/Beringia-Map_Bathymetry_web72_final.png${SIZE}"

# Chapter 2 — Colliding Cultures (same URL as download_ch2_images.sh)
echo "Chapter 2 (Colliding Cultures)"
download 2 "waldseemuller-map.jpg" "${W}/Waldseem%C3%BCller_map_2.jpg?width=640"

# Chapter 3 — British North America
echo "Chapter 3 (British North America)"
download 3 "thirteen-colonies-1775.png" "${W}/13_colonies_in_1775_%28large%29.png${SIZE}"

# Chapter 4 — Colonial Society
echo "Chapter 4 (Colonial Society)"
download 4 "triangular-trade.png" "${W}/Atlantic_Triangular_Trade,_1500-1800s.png${SIZE}"
download 4 "slave-trade-routes.jpg"   "${W}/Map_of_the_Triangular_trade.jpg${SIZE}"

# Chapter 5 — American Revolution
echo "Chapter 5 (American Revolution)"
download 5 "siege-of-yorktown.gif" "${W}/US_Army_52415_Siege_of_Yorktown_Map.gif${SIZE}"

# Chapter 6 — A New Nation
echo "Chapter 6 (A New Nation)"
download 6 "us-territory-1789.png" "${W}/United_States_1789-08-1790.png${SIZE}"

# Chapter 7 — Early Republic
echo "Chapter 7 (Early Republic)"
download 7 "louisiana-purchase.jpg" "${W}/Map_of_the_Louisiana_Purchase_Territory_-_NARA_-_594889.jpg${SIZE}"

# Chapter 8 — Market Revolution
echo "Chapter 8 (Market Revolution)"
download 8 "canals-railroads-1840.jpg" "${W}/Map_of_the_canals_%26_rail_roads_of_the_United_States,_reduced_from_the_large_map_of_the_U.S.;_engraved_by_J._Knight._LOC_98688305.jpg?width=640"

# Chapter 9 — Democracy in America
echo "Chapter 9 (Democracy in America)"
download 9 "trail-of-tears-map.jpg" "${UPLOAD}/thumb/d/d4/Trail_of_tears_map_NPS.jpg/902px-Trail_of_tears_map_NPS.jpg"

# Chapter 10 — Religion & Reform
echo "Chapter 10 (Religion & Reform)"
download 10 "ugrr-siebert-1898.png" "${W}/%22Underground%22_routes_to_Canada_%28Siebert_1898%29.png?width=640"

# Chapter 11 — Cotton Revolution (same URL as download_ch11_images.sh)
echo "Chapter 11 (Cotton Revolution)"
download 11 "slave-population-map.jpg" "${W}/Slave_population_map_1860.jpg?width=640"

# Chapter 12 — Manifest Destiny (same URL as download_ch12_images.sh)
echo "Chapter 12 (Manifest Destiny)"
download 12 "mexican-cession-map.jpg" "${UPLOAD}/thumb/4/4f/Mexican_Cession.png/640px-Mexican_Cession.png"

# Chapter 13 — Sectional Crisis (same URL as download_ch13_images.sh)
echo "Chapter 13 (Sectional Crisis)"
download 13 "reynolds-political-map.jpg" "${W}/Reynolds%27s_Political_Map_of_the_United_States_1856.jpg?width=640"

# Chapter 14 — Civil War
echo "Chapter 14 (Civil War)"
download 14 "civil-war-1861.jpg" "${W}/Map_of_the_United_States_of_America_showing_the_boundaries_of_the_Union_and_Confederate_geographical_divisions_and_departments,_June_30,_1861._LOC_99447006.jpg?width=640"
download 14 "anaconda-plan.jpg" "${UPLOAD}/thumb/b/bc/Scott-anaconda.jpg/960px-Scott-anaconda.jpg"

# Chapter 15 — Reconstruction
echo "Chapter 15 (Reconstruction)"
download 15 "reconstruction-military-districts.png" "${W}/US_Reconstruction_military_districts.png?width=640"

echo ""
echo "Done. Maps are in $BASE_DIR/images/ch1/ through ch15/."
echo "If any [FAIL]: run this script again later (Wikimedia may rate-limit), or run the specific scripts/download_chN_images.sh for that chapter."
