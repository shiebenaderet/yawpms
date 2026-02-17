#!/usr/bin/env bash
# Download all chapter maps. Saves to images/ch1 .. images/ch15.
# Filenames match the src= attributes in the HTML files.
# Skips existing files (with min-size check). Continues on per-file errors.
# Sources: Wikimedia Commons (PD/CC), LOC, NPS, NARA.
# Usage: bash scripts/download_all_maps.sh

set -u
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
BASE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
W="https://commons.wikimedia.org/wiki/Special:FilePath"
UPLOAD="https://upload.wikimedia.org/wikipedia/commons"
MIN_SIZE=5000
FAILED_LIST=()
OK=0
SKIPPED=0
TOTAL=0

download() {
  local ch="$1"
  local file="$2"
  local url="$3"
  local dest="$BASE_DIR/images/ch${ch}/${file}"
  TOTAL=$((TOTAL + 1))
  mkdir -p "$(dirname "$dest")"
  local size
  size=$(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null || echo 0)
  if [ -f "$dest" ] && [ "${size:-0}" -ge "$MIN_SIZE" ]; then
    echo "  [skip] ch${ch}/${file}"
    SKIPPED=$((SKIPPED + 1))
    return 0
  fi
  echo "  [get]  ch${ch}/${file}"
  sleep 1

  # Try up to 3 times with backoff
  local attempt
  for attempt in 1 2 3; do
    if curl -sL --fail --max-time 60 -A "$CURL_USER_AGENT" "$url" -o "$dest" 2>/dev/null; then
      break
    fi
    if [ "$attempt" -lt 3 ]; then
      echo "         [retry $attempt in $((attempt * 3))s]"
      sleep $((attempt * 3))
    fi
  done

  # Validate
  if [ -f "$dest" ]; then
    size=$(stat -f%z "$dest" 2>/dev/null || stat -c%s "$dest" 2>/dev/null || echo 0)
    if [ "${size:-0}" -lt "$MIN_SIZE" ]; then
      echo "  [FAIL] ch${ch}/${file} — got ${size:-0} bytes (likely error page)"
      FAILED_LIST+=("ch${ch}/${file}")
      rm -f "$dest"
      return 1
    fi
    local kb=$((size / 1024))
    echo "  [ok]   ch${ch}/${file} (${kb} KB)"
    OK=$((OK + 1))
    return 0
  else
    echo "  [FAIL] ch${ch}/${file} — no file written"
    FAILED_LIST+=("ch${ch}/${file}")
    return 1
  fi
}

echo ""
echo "============================================"
echo "  Map Downloader — American Yawp MS"
echo "============================================"
echo "  Target: $BASE_DIR/images/chN/"
echo "  (Skips existing files; retries on failure)"
echo ""

# ── Chapter 1 — Indigenous America ──
echo "Chapter 1 (Indigenous America)"
download 1 "beringia-map.jpg"         "${W}/Beringia_land_bridge-noaagov.gif?width=800"
download 1 "native-cultures-map.png"  "${W}/Early_Localization_Native_Americans_USA.jpg?width=800"

# ── Chapter 2 — Colliding Cultures ──
echo "Chapter 2 (Colliding Cultures)"
download 2 "waldseemuller-map.jpg"    "${W}/Waldseem%C3%BCller_map_2.jpg?width=640"
download 2 "columbus-voyages-map.png" "${W}/Viajes_de_colon_en.svg?width=800"
download 2 "european-claims-map.png"  "${W}/Non-Native_Nations_Claim_over_NAFTA_countries_1750.png?width=800"

# ── Chapter 3 — British North America ──
echo "Chapter 3 (British North America)"
download 3 "thirteen-colonies-map.png" "${W}/Thirteen_Colonies_1775.svg?width=600"

# ── Chapter 4 — Colonial Society ──
echo "Chapter 4 (Colonial Society)"
download 4 "triangular-trade-map.png" "${W}/Triangle_trade2.png?width=800"

# ── Chapter 5 — American Revolution ──
echo "Chapter 5 (American Revolution)"
download 5 "siege-of-yorktown.gif"       "${W}/US_Army_52415_Siege_of_Yorktown_Map.gif?width=800"
download 5 "revolution-battles-map.png"  "${W}/American_Revolutionary_War_battles_map.svg?width=600"

# ── Chapter 6 — A New Nation ──
echo "Chapter 6 (A New Nation)"
download 6 "us-territory-1789-map.png"   "${W}/United_States_1789-08-1790.png?width=800"

# ── Chapter 7 — Early Republic ──
echo "Chapter 7 (Early Republic)"
download 7 "louisiana-purchase-map.png"       "${W}/LouisianaPurchase.png?width=800"
download 7 "lewis-clark-expedition-map.png"   "${W}/Lewis_and_clark-expedition.jpg?width=800"

# ── Chapter 8 — Market Revolution ──
echo "Chapter 8 (Market Revolution)"
download 8 "erie-canal-map.png"         "${W}/Erie_Canal_map.png?width=800"
download 8 "railroads-1860-map.jpg"     "${W}/Railroad_map_of_the_United_States_1861.jpg?width=800"

# ── Chapter 9 — Democracy in America ──
echo "Chapter 9 (Democracy in America)"
download 9 "trail-of-tears-map.png"   "${W}/Trails_of_Tears_en.png?width=800"
download 9 "indian-cessions-map.jpg"  "${W}/Indiancessions.jpg?width=800"

# ── Chapter 10 — Religion & Reform ──
echo "Chapter 10 (Religion & Reform)"
download 10 "underground-railroad-map.jpg" "${W}/Undergroundrailroadsmall2.jpg?width=800"

# ── Chapter 11 — Cotton Revolution ──
echo "Chapter 11 (Cotton Revolution)"
download 11 "domestic-slave-trade-map.png" "${W}/Slave_trade_routes_in_the_USA.svg?width=800"
download 11 "slave-population-map.jpg"     "${UPLOAD}/thumb/5/5e/SlavePopulationUS1860.jpg/960px-SlavePopulationUS1860.jpg"

# ── Chapter 12 — Manifest Destiny ──
echo "Chapter 12 (Manifest Destiny)"
download 12 "mexican-cession-map.jpg"     "${UPLOAD}/thumb/4/4f/Mexican_Cession.png/640px-Mexican_Cession.png"
download 12 "oregon-territory-map.png"    "${W}/Oregon_territory_1848.svg?width=600"

# ── Chapter 13 — Sectional Crisis ──
echo "Chapter 13 (Sectional Crisis)"
download 13 "reynolds-political-map.jpg"  "${W}/Reynolds%27s_Political_Map_of_the_United_States_1856.jpg?width=640"
download 13 "compromise-1850-map.png"     "${W}/Compromise_of_1850.png?width=800"

# ── Chapter 14 — Civil War ──
echo "Chapter 14 (Civil War)"
download 14 "anaconda-plan-map.jpg"       "${W}/Scott-anaconda.jpg?width=800"
download 14 "civil-war-states-map.png"    "${W}/US_Secession_map_1861.svg?width=800"

# ── Chapter 15 — Reconstruction ──
echo "Chapter 15 (Reconstruction)"
download 15 "reconstruction-districts-map.png" "${W}/Reconstruction_Military_Districts.svg?width=600"

# ── Summary ──
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
  echo "  Failed maps:"
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
