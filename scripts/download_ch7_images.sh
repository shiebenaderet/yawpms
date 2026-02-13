#!/usr/bin/env bash
# Download images for Chapter 7: The Early Republic
# Images sourced from The American Yawp (CC BY-SA 4.0) and Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch7_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$SCRIPT_DIR/../images/ch7"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 7 images to $IMG_DIR ..."

declare -A IMAGES=(
  # From The American Yawp (CC BY-SA 4.0)
  ["america-guided-by-wisdom.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/America-Guided-by-Wisdom-30.jpg"
  ["haitian-revolution.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/Haitian-Revolution.jpg"
  ["james-peale-family.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/The_artist_and_his_family_james_peale.jpg"
  ["jefferson-banner.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/Jefferson-Banner.jpg"
  ["uss-chesapeake.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/USS-Chesapeake.jpg"
  ["red-jacket.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/Red-Jacket.jpg"
  ["tenskwatawa.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/Ten-squat-a-way-2.jpg"
  ["british-indians-cartoon.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/British-Indians-Savage-War-of-1812.jpg"
  ["washington-burning.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/Washington-Burning.jpg"
  ["hartford-convention.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/Hartford-Convention.jpg"
  ["camp-meeting.jpg"]="http://www.americanyawp.com/text/wp-content/uploads/Camp_Meeting_1819.jpg"

  # From Wikimedia Commons (public domain)
  ["banneker-almanac.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Benjamin_Banneker%27s_Pennsylvania%2C_Delaware%2C_Maryland%2C_and_Virginia_Almanac_and_Ephemeris%2C_for_the_Year_of_Our_Lord_1795.jpg/440px-Benjamin_Banneker%27s_Pennsylvania%2C_Delaware%2C_Maryland%2C_and_Virginia_Almanac_and_Ephemeris%2C_for_the_Year_of_Our_Lord_1795.jpg"
  ["monticello.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Thomas_Jefferson%27s_Monticello.JPG/640px-Thomas_Jefferson%27s_Monticello.JPG"
  ["lewis-and-clark.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Lewis_and_clark-expedition.jpg/640px-Lewis_and_clark-expedition.jpg"
  ["john-marshall.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/John_Marshall_by_Henry_Inman%2C_1832.jpg/440px-John_Marshall_by_Henry_Inman%2C_1832.jpg"
  ["battle-of-new-orleans.jpg"]="https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Battle_of_New_Orleans.jpg/640px-Battle_of_New_Orleans.jpg"
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
