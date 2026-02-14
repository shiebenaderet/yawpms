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
  ["slave-auction.jpg"]="https://images.nypl.org/index.php?id=413059&t=w"
  ["slave-population-map.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/SlavePopulationUS1860.jpg/960px-SlavePopulationUS1860.jpg"
)

MIN_SIZE=5000
for local in "${!IMAGES[@]}"; do
  url="${IMAGES[$local]}"
  dest="$IMG_DIR/$local"
  if [ -f "$dest" ] && [ "$(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null)" -ge "$MIN_SIZE" ]; then
    echo "  [skip] $local"
  else
    echo "  [download] $local"
    sleep 2
    if ! curl -sL --fail --max-time 60 -A "$CURL_USER_AGENT" "$url" -o "$dest" 2>/dev/null; then
      echo "  [retry in 5s] $local"
      sleep 5
      curl -sL --fail --max-time 60 -A "$CURL_USER_AGENT" "$url" -o "$dest" 2>/dev/null || true
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
