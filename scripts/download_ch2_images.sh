#!/usr/bin/env bash
# Download images for Chapter 2: Colliding Cultures
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch2_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch2"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 2 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["champlain-habitation.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Champlain_Habitation_de_Quebec.jpg?width=640"
  ["waldseemuller-map.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Waldseem%C3%BCller_map_2.jpg?width=640"
  ["de-bry-spanish-cruelty.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Perros_De_Bry.jpg?width=640"
  ["secotan-village.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Village_of_Secoton.jpg?width=640"
  ["negotiating-peace.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Negotiating_peace_with_the_Indians.jpg?width=640"
  ["castello-plan.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Castelloplan.jpg/640px-Castelloplan.jpg"
  ["new-orleans-1726.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Nouvelle_Orleans_1728_map.jpg/640px-Nouvelle_Orleans_1728_map.jpg"
  ["battle-gravelines.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/La_batalla_de_Gravelinas%2C_por_Nicholas_Hilliard.jpg/640px-La_batalla_de_Gravelinas%2C_por_Nicholas_Hilliard.jpg"
)

for local in "${!IMAGES[@]}"; do
  url="${IMAGES[$local]}"
  dest="$IMG_DIR/$local"
  if [ -f "$dest" ]; then
    echo "  [skip] $local already exists"
  else
    echo "  [download] $local"
    if curl -sL --fail "$url" -o "$dest" 2>/dev/null; then
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
