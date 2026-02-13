#!/usr/bin/env bash
# Download images for Chapter 10: Religion and Reform
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch10_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch10"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 10 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["camp-meeting-revival.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Camp_meeting_of_the_Methodists_in_N._America_J._Milbert_del_M._Dubourg_sculp_(cropped).jpg?width=640"
  ["frederick-douglass.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Frederick_Douglass_%28circa_1879%29.jpg?width=440"
  ["seneca-falls.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Woman%27s_Rights_Convention.jpg?width=640"
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
