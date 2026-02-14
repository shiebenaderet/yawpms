#!/usr/bin/env bash
# Download images for Chapter 14: The Civil War
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch14_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch14"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 14 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["fort-sumter.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Bombardment_of_Fort_Sumter%2C_Charleston_Harbor.jpg?width=640"
  ["usct-soldiers.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/District_of_Columbia._Company_E%2C_4th_U.S._Colored_Infantry%2C_at_Fort_Lincoln_LOC_cwpb.04294.tif?width=640"
  ["field-hospital.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Amputation_being_performed_in_a_hospital_tent%2C_Gettysburg%2C_07-1863_-_NARA_-_520203.jpg?width=640"
  ["soldier-family.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Sgt._Samuel_Smith%2C_African_American_soldier_in_Union_uniform_with_wife_and_two_daughters.jpg/440px-Sgt._Samuel_Smith%2C_African_American_soldier_in_Union_uniform_with_wife_and_two_daughters.jpg"
  ["antietam-dead.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Bodies_on_the_battlefield_at_antietam.jpg?width=640"
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
