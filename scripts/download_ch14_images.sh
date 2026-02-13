#!/usr/bin/env bash
# Download images for Chapter 14: The Civil War
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch14_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch14"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 14 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["fort-sumter.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Bombardment_of_Fort_Sumter%2C_Charleston_Harbor.jpg?width=640"
  ["usct-soldiers.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/District_of_Columbia._Company_E%2C_4th_U.S._Colored_Infantry%2C_at_Fort_Lincoln_LOC_cwpb.04294.tif?width=640"
  ["field-hospital.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Amputation_being_performed_in_a_hospital_tent%2C_Gettysburg%2C_07-1863_-_NARA_-_520203.jpg?width=640"
  ["soldier-family.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/African_American_soldier_in_Union_uniform_with_wife_and_two_daughters.jpg?width=440"
  ["antietam-dead.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Bodies_on_the_battlefield_at_antietam.jpg?width=640"
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
