#!/usr/bin/env bash
# Download images for Primary Source Reader (ch1–ch15 source pages)
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_primary_source_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../primary-sources/images"
mkdir -p "$IMG_DIR"

echo "============================================"
echo "  Primary Source Reader — Image Downloader"
echo "============================================"
echo "  Target: $IMG_DIR"
echo "  (Skips existing files; retries on failure)"
echo ""

# ---- Image manifest ----
# Key = local filename, Value = Wikimedia Special:FilePath URL
# All images are public domain (pre-1929 or US government works).

declare -A IMAGES=(
  # Ch1 Source 1.2 — Monks Mound, Cahokia (photo, public domain)
  ["ch1-monks-mound.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Monks_Mound_in_July.JPG?width=800"

  # Ch1 Source 1.4 — Birch bark box, southeastern Ojibwa (Peabody Museum)
  ["ch1-birch-bark.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Box_(birchbark),_probably_southeastern_Ojibwa,_post-1865_-_Native_American_collection_-_Peabody_Museum,_Harvard_University_-_DSC05471.JPG?width=800"

  # Ch2 Source 2.3 — De Bry, Columbus Landing on Hispaniola (1594)
  ["ch2-columbus-landing.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Columbus_landing_on_Hispaniola.JPG?width=800"

  # Ch3 Source 3.3 — Simon van de Passe, Pocahontas (1616)
  ["ch3-pocahontas.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Pocahontas_by_Simon_van_de_Passe.jpg?width=600"

  # Ch4 Source 4.2 — Benjamin Franklin, "Join, or Die" (1754)
  ["ch4-join-or-die.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Benjamin_Franklin_-_Join_or_Die.jpg?width=800"

  # Ch6 Source 6.4 — "The Providential Detection" (c. 1800)
  ["ch6-providential-detection.jpg"]="https://www.americanyawp.com/reader/wp-content/uploads/server.np-2-1-1000x1166.jpeg"

  # Ch7 Source 7.4 — Bombardment of Fort McHenry (Bower, c. 1814)
  ["ch7-fort-mchenry.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Ft._Henry_bombardement_1814.jpg?width=800"

  # Ch8 Source 8.4 — Erie Canal view
  ["ch8-erie-canal.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Erie_Canal.jpg?width=800"

  # Ch9 Source 9.4 — Cherokee Phoenix newspaper first issue (1828)
  ["ch9-cherokee-phoenix.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Cherokee_Phoenix_first_issue.jpg?width=800"

  # Ch11 Source 11.3 — Slave auction broadside/advertisement
  ["ch11-slave-broadside.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Slave_Auction_Ad.jpg?width=600"

  # Ch12 Source 12.3 — John Gast, "American Progress" (1872)
  ["ch12-american-progress.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/American_Progress_%28John_Gast_painting%29.jpg?width=800"

  # Ch14 Source 14.4 — Contraband camp, Richmond VA (c. 1865)
  ["ch14-contraband-camp.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Contraband_camp,_Richmond,_Va,_1865_-_NARA_-_524494.jpg?width=800"

  # Ch15 Source 15.4 — Thomas Nast, "Worse Than Slavery" (1874)
  ["ch15-worse-than-slavery.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Worse_than_Slavery_%281874%29%2C_by_Thomas_Nast.jpg?width=600"
)

# ---- Download loop ----
MIN_SIZE=5000
TOTAL=${#IMAGES[@]}
COUNT=0
OK=0
SKIPPED=0
FAILED_LIST=()

for local in $(echo "${!IMAGES[@]}" | tr ' ' '\n' | sort); do
  url="${IMAGES[$local]}"
  dest="$IMG_DIR/$local"
  COUNT=$((COUNT + 1))

  if [ -f "$dest" ] && [ "$(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null)" -ge "$MIN_SIZE" ]; then
    echo "  [$COUNT/$TOTAL] [skip] $local already exists"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  echo "  [$COUNT/$TOTAL] [download] $local"
  sleep 2

  # Attempt 1
  if ! curl -sL --fail --max-time 60 -A "$CURL_USER_AGENT" "$url" -o "$dest" 2>/dev/null; then
    echo "           [retry 1 in 5s] $local"
    sleep 5
    # Attempt 2
    if ! curl -sL --fail --max-time 60 -A "$CURL_USER_AGENT" "$url" -o "$dest" 2>/dev/null; then
      echo "           [retry 2 in 10s] $local"
      sleep 10
      # Attempt 3
      curl -sL --fail --max-time 60 -A "$CURL_USER_AGENT" "$url" -o "$dest" 2>/dev/null || true
    fi
  fi

  # Validate
  if [ -f "$dest" ]; then
    size=$(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null)
    if [ "${size:-0}" -lt "$MIN_SIZE" ]; then
      echo "           [FAILED] $local — got ${size:-0} bytes (likely error page)"
      rm -f "$dest"
      FAILED_LIST+=("$local")
    else
      kb=$(( size / 1024 ))
      echo "           [ok] $local (${kb} KB)"
      OK=$((OK + 1))
    fi
  else
    echo "           [FAILED] $local — no file written"
    FAILED_LIST+=("$local")
  fi
done

# ---- Summary ----
echo ""
echo "============================================"
echo "  Results"
echo "============================================"
echo "  Downloaded: $OK"
echo "  Skipped:    $SKIPPED (already existed)"
echo "  Failed:     ${#FAILED_LIST[@]}"
echo "  Total:      $TOTAL"
echo "============================================"

if [ ${#FAILED_LIST[@]} -gt 0 ]; then
  echo ""
  echo "  Failed images:"
  for f in "${FAILED_LIST[@]}"; do
    echo "    - $f"
  done
  echo ""
  echo "  To retry, run this script again — it skips"
  echo "  successfully downloaded files."
  echo ""
  echo "  If a URL is broken, search Wikimedia Commons"
  echo "  for the image title and update the URL above."
fi

echo ""
echo "Image sources (all public domain):"
echo "  - Wikimedia Commons"
echo "  - Library of Congress"
echo "  - Smithsonian Institution"
echo ""
echo "Files saved to: $IMG_DIR"
ls -la "$IMG_DIR"
