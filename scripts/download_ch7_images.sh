#!/usr/bin/env bash
# Download images for Chapter 7: The Early Republic
# Image licences VARY BY FIGURE; each entry below records its own. Do NOT assume
# public domain, and do NOT rely on this header for any individual image.
# These require NAMED ATTRIBUTION in the caption:
#   louisiana-purchase-map.png  Ernst Schuette, CC BY-SA 3.0
#   monticello.jpg              Martin Falbisoner, CC BY-SA 3.0
#   lewis-clark-route-map.png   EncMstr / Urban / Pandat, CC BY-SA 4.0
# Usage: bash scripts/download_ch7_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/download_common.sh"
IMG_DIR="$SCRIPT_DIR/../images/ch7"
mkdir -p "$IMG_DIR"

echo "Downloading Chapter 7 images to $IMG_DIR ..."

declare -A IMAGES=(
  # "Territory of Louisiana, 1803-1819" (Map No. 4) from Frank Bond, Historical Sketch
  # of "Louisiana" and the Louisiana Purchase, U.S. General Land Office (GPO, 1912).
  # Drawn by I. P. Bartlett and C. J. Hein; printed by the Columbia Planograph Co.,
  # Washington D.C. -- all four names are legible on the plate itself. Work of the
  # U.S. government, public domain.
  # NOTE: a 1912 RETROSPECTIVE map. It draws 20th-century state lines (Oklahoma,
  # Wyoming, the Dakotas) over 1803 territory, so the caption must not present it as
  # a period document.
  ["louisiana-purchase.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Frank_bond_1912_louisiana_and_the_louisiana_purchase.jpg?width=960"
  # Library of Congress, LC control no. 2010634241; no known restrictions on publication
  ["america-guided-by-wisdom.jpg"]="https://tile.loc.gov/storage-services/service/pnp/ds/04700/04764r.jpg"
  ["haitian-revolution.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/January_Suchodolski_-_Legionaries_at_San_Domingo_-_MP_2606_-_National_Museum_in_Warsaw.jpg?width=960"
  # Banneker's ALMANACK AND EPHEMERIS for 1792 (first edition), Baltimore: William Goddard
  # and James Angell, 1791. LOC Rare Book and Special Collections (rbcmisc/ody/ody0214).
  # Replaced an unsourced scan of the 1795 John Fisher edition on 2026-09-11: its manifest URL
  # was a Commons title that never existed and 404s, and the scan could not be traced to any
  # repository (absent from Commons, LOC, Internet Archive; EXIF stripped). The 1792 edition is
  # also the better fit -- it is the work whose calculations Banneker sent Jefferson with his
  # August 1791 letter, quoted immediately above the figure. Public domain.
  ["banneker-almanac-1792.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/BannekerAlmanac.jpg?width=640"
  # "The Peale Family" by CHARLES WILLSON Peale, begun c.1773, finished 1809.
  # New-York Historical Society. Public domain.
  # *** The Commons file is MISNAMED "The artist and his family james peale.jpg" and
  # *** its metadata says "James Peale, 1795". That is a different, smaller painting.
  # *** The image on disk is unmistakably C.W. Peale's group portrait: eleven figures,
  # *** the painter with a palette at left, busts on a shelf, the dog Argus in front.
  # *** Verified from the artifact, not from the Commons record.
  ["james-peale-family.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/The_artist_and_his_family_james_peale.jpg?width=640"
  ["camp-meeting.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Camp_meeting_of_the_Methodists_in_N._America_J._Milbert_del_M._Dubourg_sculp_(cropped).jpg?width=640"
  # Republican committee circular, Richmond, 9 Aug 1800 ("Form of the Republican Ticket").
  # Was filed as "jefferson-banner.jpg" pointing at a Commons title that never existed and
  # 404s; it is not a banner and names no candidate. Verified 2026-09-11 against the physical
  # item (matching "850" stamp and pencil no. 116457) at LOC item 2020775530,
  # Printed Ephemera Portfolio 181, Folder 5. Public domain.
  ["republican-ticket-1800.jpg"]="https://tile.loc.gov/image-services/iiif/service:rbc:rbpe:rbpe18:rbpe181:18100500:001dr/full/640,/0/default.jpg"
  ["monticello.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Thomas_Jefferson's_Monticello.JPG?width=640"
  ["lewis-and-clark.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Lewis_and_clark-expedition.jpg?width=640"
  ["john-marshall.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/John_Marshall_by_Henry_Inman%2C_1832.jpg?width=440"
  # The Chesapeake's single shot during the Chesapeake-Leopard affair, 22 June 1807. An 1896
  # illustration from Willis J. Abbot, The Naval History of the United States, vol. 1 (Peter
  # Fenelon Collier), Part II, ch. IX -- NOT a contemporary depiction; the caption says so.
  # Artist signed the drawing but the signature is illegible and uncredited in the book.
  # Public domain. The caption called this "the British attack" until 2026-09-11; it actually
  # shows Chesapeake's own crew firing the one gun they managed before striking their colours.
  ["uss-chesapeake.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Onlyshotofchesapeake.jpg"
  # LOC LC-DIG-pga-07567, item 2013645353 (public domain)
  ["red-jacket.jpg"]="https://tile.loc.gov/storage-services/service/pnp/pga/07500/07567r.jpg"
  # Tenskwatawa (the Shawnee Prophet). A line ENGRAVING, not a painting, and not
  # drawn from life. The caption claimed "painted by George Catlin in 1831" until
  # 2026-09-11; Catlin's Tenskwatawa is a full-colour oil and looks nothing like
  # this. Commons carries no artist or date for the file. Public domain.
  ["tenskwatawa.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Tenskwatawa.jpg?width=440"
  # "A scene on the frontiers as practiced by the humane British and their worthy allies!", 1812.
  # Etching with watercolour, LOC Popular Graphic Arts, LCCN 2002708980 (ppmsca.10752).
  # NOT the William Charles print: the LOC abstract identifies this impression as an anonymous
  # copy after Charles, "cruder but similar in detail". The caption credited Charles outright
  # until 2026-09-11. Public domain.
  ["british-indians-cartoon.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/A_scene_on_the_frontiers_as_practiced_by_the_humane_British_and_their_worthy_allies%21_LCCN2002708980.jpg?width=640"
  ["washington-burning.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Burning_of_Washington_1814.jpg?width=640"
  ["battle-of-new-orleans.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/Battle_of_New_Orleans.jpg?width=640"
  ["hartford-convention.jpg"]="https://commons.wikimedia.org/wiki/Special:FilePath/TheHartfordConventionOrLeapNoLeap.jpg?width=640"
  # Maps
  ["louisiana-purchase-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/LouisianaPurchase.png?width=800"
  # Lewis and Clark route, 1804-1806. MODERN map (2007) by Wikimedia contributors
  # EncMstr, Urban and Pandat. *** CC BY-SA 4.0 -- ATTRIBUTION REQUIRED in the caption.
  # Replaced a figure that was byte-identical to lewis-and-clark.jpg -- a Russell
  # painting carrying a "Map" badge and a route description.
  ["lewis-clark-route-map.png"]="https://commons.wikimedia.org/wiki/Special:FilePath/Carte_Lewis-Clark_Expedition-en.png?width=1100"
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
