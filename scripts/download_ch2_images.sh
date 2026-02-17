#!/usr/bin/env bash
# Download images for Chapter 2: Colliding Cultures
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch2_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch2"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 2 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["champlain-habitation.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Champlain_Habitation_de_Quebec.jpg?width=640"
  ["waldseemuller-map.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Waldseem%C3%BCller_map_2.jpg?width=640"
  ["de-bry-spanish-cruelty.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Perros_De_Bry.jpg?width=640"
  ["secotan-village.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Village_of_Secoton.jpg?width=640"
  ["negotiating-peace.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Negotiating_peace_with_the_Indians.jpg?width=640"

  # Maps
  ["columbus-voyages-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Viajes_de_colon_en.svg?width=800"
  ["european-claims-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Non-Native_Nations_Claim_over_NAFTA_countries_1750.png?width=800"
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
