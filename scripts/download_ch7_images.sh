#!/usr/bin/env bash
# Download images for Chapter 7: The Early Republic
# Images sourced from Wikimedia Commons (public domain / CC BY-SA)
# Usage: bash scripts/download_ch7_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch7"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 7 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["america-guided-by-wisdom.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/America_guided_by_wisdom.jpg?width=640"
  ["haitian-revolution.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Bataille_de_San_Domingo.jpg?width=640"
  ["banneker-almanac.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Benjamin_Banneker's_Pennsylvania%2C_Delaware%2C_Maryland%2C_and_Virginia_Almanac_and_Ephemeris%2C_for_the_Year_of_Our_Lord_1795.jpg?width=440"
  ["james-peale-family.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/James_Peale_The_Artist_and_His_Family.jpg?width=640"
  ["camp-meeting.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Camp_meeting_of_the_Methodists_in_N._America_J._Milbert_del_M._Dubourg_sculp_(cropped).jpg?width=640"
  ["jefferson-banner.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Jefferson_campaign_banner%2C_1800.jpg?width=640"
  ["monticello.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Thomas_Jefferson's_Monticello.JPG?width=640"
  ["lewis-and-clark.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Lewis_and_clark-expedition.jpg?width=640"
  ["john-marshall.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/John_Marshall_by_Henry_Inman%2C_1832.jpg?width=440"
  ["uss-chesapeake.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Chesapeake_Leopard.jpg?width=640"
  ["red-jacket.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Red_Jacket_by_Charles_Bird_King.jpg?width=440"
  ["tenskwatawa.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Tenskwatawa.jpg?width=440"
  ["british-indians-cartoon.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/A_scene_on_the_frontiers_as_practiced_by_the_humane_British_and_their_worthy_allies.jpg?width=640"
  ["washington-burning.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Burning_of_Washington_1814.jpg?width=640"
  ["battle-of-new-orleans.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Battle_of_New_Orleans.jpg?width=640"
  ["hartford-convention.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Hartford_Convention_or_Leap_No_Leap.jpg?width=640"

  # Maps
  ["louisiana-purchase-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/LouisianaPurchase.png?width=800"
  ["lewis-clark-expedition-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Lewis_and_clark-expedition.jpg?width=800"
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
