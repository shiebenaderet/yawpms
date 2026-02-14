#!/usr/bin/env bash
# Download images for Chapter 7: The Early Republic
# Images sourced from Wikimedia Commons (public domain / CC BY-SA)
# Usage: bash scripts/download_ch7_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch7"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 7 images to $IMG_DIR ..."

declare -A IMAGES=(
  ["america-guided-by-wisdom.jpg"]="https://cdn.loc.gov/service/pnp/ds/04700/04764r.jpg"
  ["haitian-revolution.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/January_Suchodolski_-_Legionaries_at_San_Domingo_-_MP_2606_-_National_Museum_in_Warsaw.jpg?width=640"
  ["banneker-almanac.jpg"]="https://damscdn.mdhistory.org/resource/2241/sc2/2241-0-sc2.jpg"
  ["james-peale-family.jpg"]="https://upload.wikimedia.org/wikipedia/commons/1/1c/The_Peale_Family.jpeg"
  ["camp-meeting.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Camp_meeting_of_the_Methodists_in_N._America_J._Milbert_del_M._Dubourg_sculp_%28cropped%29.jpg?width=640"
  ["jefferson-banner.jpg"]="https://www.loc.gov/exhibits/creating-the-united-states/BillofRights/Electionof1800/Assets/us0132_01_enlarge.jpg"
  ["monticello.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Thomas_Jefferson%27s_Monticello.JPG?width=640"
  ["lewis-and-clark.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Lewis_and_clark-expedition.jpg?width=640"
  ["john-marshall.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/John_Marshall_by_Henry_Inman%2C_1832.jpg?width=440"
  ["uss-chesapeake.jpg"]="https://upload.wikimedia.org/wikipedia/commons/2/28/Onlyshotofchesapeake.jpg"
  ["red-jacket.jpg"]="https://cdn.loc.gov/service/pnp/pga/07500/07567r.jpg"
  ["tenskwatawa.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Tenskwatawa.jpg?width=440"
  ["british-indians-cartoon.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/A_scene_on_the_frontiers_as_practiced_by_the_humane_British_and_their_worthy_allies%21_LCCN2002708980.jpg/640px-A_scene_on_the_frontiers_as_practiced_by_the_humane_British_and_their_worthy_allies%21_LCCN2002708980.jpg"
  ["washington-burning.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Burning_of_Washington_1814.jpg?width=640"
  ["battle-of-new-orleans.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Battle_of_New_Orleans.jpg?width=640"
  ["hartford-convention.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/TheHartfordConventionOrLeapNoLeap.jpg/640px-TheHartfordConventionOrLeapNoLeap.jpg"
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
