#!/usr/bin/env bash
# Download images for Chapter 1: Indigenous America
# Images sourced from The American Yawp (CC BY-SA 4.0) and Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch1_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch1"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 1 images to $IMG_DIR ..."

declare -A IMAGES=(
  # From The American Yawp (CC BY-SA 4.0)
  ["cahokia-mounds.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/Cahokia.jpg"
  ["tenochtitlan.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/Tenochtitlan.jpg"
  ["columbus-landing.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/Columbus_landing_on_Hispaniola.jpg"
  ["casta-painting.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/Casta_painting.jpg"

  # From Wikimedia Commons (public domain)
  ["mesa-verde.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Mesa_Verde_National_Park_Cliff_Palace_Right_Part_2006_09_12.jpg/640px-Mesa_Verde_National_Park_Cliff_Palace_Right_Part_2006_09_12.jpg"
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
