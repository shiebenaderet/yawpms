#!/usr/bin/env bash
# Download images for Chapter 2: Colliding Cultures
# Images sourced from Wikimedia Commons (public domain)
# Usage: bash scripts/download_ch2_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch2"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 2 images to $IMG_DIR ..."

declare -A IMAGES=(
  # "La Nouvelle Orleans en 1728" -- French colonial town plan of New Orleans.
  # Public domain. Identified 2026-09-11 by matching aspect ratio: the committed file
  # is 960x729 and this source returns exactly 960x729 at width=960.
  # NOTE: the committed FILENAME says 1726. The map's own title cartouche reads 1728,
  # and the figcaption and alt text correctly say 1728 -- the filename is the outlier.
  ["new-orleans-1726.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Nouvelle_Orleans_1728_map.jpg?width=960"

  # New Amsterdam 1660 -- 1916 REDRAFT by John Wolcott Adams (1874-1925) of the original
  # Castello Plan survey. Public domain. NOT a 1660 document; the cartouche says "Redraft".
  ["castello-plan.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Redraft_of_the_Castello_Plan_New_Amsterdam_in_1660_by_John_Wolcott_Adams.jpg?width=960"

  # Spanish Armada off Gravelines, anonymous English School, painted between 1588 and 1600 --
  # so the caption's "period painting" is accurate. Public domain.
  ["battle-gravelines.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Escudo_real_hisp%C3%A1nico_no_English_ships_and_the_Spanish_Armada%2C_August_1588.jpg?width=960"
  ["champlain-habitation.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Champlain_Habitation_de_Quebec.jpg?width=640"
  # Waldseemuller world map, 1507 -- the first to name "America". Public domain.
  # The old URL spelled the title with an umlaut (Waldseem%C3%BCller); the Commons file uses
  # a plain "u", so it 404d. Verified by aspect ratio against the 13708x7590 original.
  ["waldseemuller-map.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Waldseemuller_map_2.jpg?width=960"
  # A Theodor de Bry engraving for Las Casas' Narratio regionum Indicarum, 1598: Spanish
  # soldiers driving a column of Indigenous captives, including women carrying infants.
  # Plate numbered "4" at the foot. Public domain by date.
  # DIGITAL SOURCE NOT ESTABLISHED. The old URL ("Perros De Bry.jpg" -- perros = dogs) 404d,
  # and did not describe this image either: there are no dogs in it. Checked the Commons
  # Narratio/Brevisima categories and the BnF btv1b20000085 series of 18 plates (those are
  # full book pages, 1024x1536); none matches this crop. A sourced 1598 de Bry plate does
  # exist ("Conquistadors' abuses of Amerindians") but shows a different, considerably more
  # graphic torture scene -- a poor swap for a grade 6-8 page. Kept and marked UNKNOWN.
  ["de-bry-spanish-cruelty.jpg"]="UNKNOWN"
  # The Algonquian village of Secoton, watercolour by John White, 1585. Public domain.
  # Filed on Commons under a German title, which is why "Village of Secoton.jpg" 404d.
  ["secotan-village.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/North_carolina_algonkin-dorf.jpg?width=960"
  # Benjamin West, "The Treaty of Penn with the Indians", 1771-72 (Pennsylvania Academy of the
  # Fine Arts). Public domain. Aspect matches the local file (1.4371 vs 1.4375).
  # The caption called this "a 17th-century engraving" until 2026-09-11. It is neither an
  # engraving nor 17th-century: it is an oil painting made ~90 years after the 1682 treaty it
  # depicts, commissioned by Penn's son. The caption now says so.
  ["negotiating-peace.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Treaty_of_Penn_with_Indians_by_Benjamin_West.jpg?width=960"

  # Maps
  ["columbus-voyages-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Viajes_de_colon_en.svg?width=800"
  ["european-claims-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Non-Native_Nations_Claim_over_NAFTA_countries_1750.png?width=800"
)

for local in "${!IMAGES[@]}"; do
  url="${IMAGES[$local]}"
  dest="$IMG_DIR/$local"
  if [ -f "$dest" ]; then
    echo "  [skip] $local already exists"
  else
    echo "  [download] $local"
    if curl -sL --fail --max-time 60 -A "$CURL_USER_AGENT" "$url" -o "$dest" 2>/dev/null; then
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
