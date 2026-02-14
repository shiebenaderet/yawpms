#!/usr/bin/env bash
# Download images for Chapter 6: A New Nation
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch6_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch6"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 6 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["federal-pillars.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Eleventh_Pillar.jpg/600px-Eleventh_Pillar.jpg"
  ["shays-shattuck.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Shays%27_Rebellion.jpg/600px-Shays%27_Rebellion.jpg"
  ["independence-hall.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Independence_Hall_10.jpg/800px-Independence_Hall_10.jpg"
  ["madison.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/James_Madison.jpg/500px-James_Madison.jpg"
  ["hamilton.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Alexander_Hamilton_portrait_by_John_Trumbull_1806.jpg/500px-Alexander_Hamilton_portrait_by_John_Trumbull_1806.jpg"
  ["execution-louis-xvi.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Execution_of_Louis_XVI.jpg/800px-Execution_of_Louis_XVI.jpg"
  ["anti-jefferson-cartoon.jpeg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Jefferson-LOC.jpg/500px-Jefferson-LOC.jpg"
  ["us-capitol-1800.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/USCapitol1800.jpg/800px-USCapitol1800.jpg"
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
echo "Note: us-territory-1789.png (map) is provided by scripts/download_all_maps.sh"
ls -la "$IMG_DIR"
