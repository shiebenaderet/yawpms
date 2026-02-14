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
  ["waldseemuller-map.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Waldseemuller_map_2.jpg/960px-Waldseemuller_map_2.jpg"
  ["de-bry-spanish-cruelty.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Conquistadors_espagnols_utilisant_les_Am%C3%A9rindiens_comme_porteurs.jpg?width=640"
  ["secotan-village.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/De_Bry_-_America_Part_1_-_Algonquin_village_-_HLABG.png?width=640"
  ["negotiating-peace.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Treaty_of_Penn_with_Indians_by_Benjamin_West.jpg?width=640"
  ["castello-plan.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Castelloplan.jpg?width=640"
  ["new-orleans-1726.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Nouvelle_Orleans_1728_map.jpg?width=960"
  ["battle-gravelines.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/La_batalla_de_Gravelinas,_por_Nicholas_Hilliard.jpg?width=640"
)

MIN_SIZE=5000
for local in "${!IMAGES[@]}"; do
  url="${IMAGES[$local]}"
  dest="$IMG_DIR/$local"
  if [ -f "$dest" ] && [ "$(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null)" -ge "$MIN_SIZE" ]; then
    echo "  [skip] $local already exists"
  else
    echo "  [download] $local"
    sleep 2
    if ! curl -sL --fail --max-time 60 "$url" -o "$dest" 2>/dev/null; then
      echo "  [retry in 5s] $local"
      sleep 5
      curl -sL --fail --max-time 60 "$url" -o "$dest" 2>/dev/null || true
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
ls -la "$IMG_DIR"
