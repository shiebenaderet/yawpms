#!/bin/bash
# ============================================================
# download-images.sh
# Downloads public-domain images from Wikimedia Commons
# for The American Yawp Middle School Edition
#
# Usage: bash download-images.sh
#
# All images are public domain or CC-licensed via Wikimedia Commons.
# ============================================================

set -e

IMAGES_DIR="$(cd "$(dirname "$0")" && pwd)/images"
UA="YawpMS-Textbook/1.0 (https://github.com/shiebenaderet/yawpms; educational project)"

download() {
  local dir="$1"
  local filename="$2"
  local url="$3"
  local dest="$IMAGES_DIR/$dir/$filename"

  if [ -f "$dest" ]; then
    echo "  [skip] $dir/$filename (already exists)"
    return
  fi

  echo "  [download] $dir/$filename"
  mkdir -p "$IMAGES_DIR/$dir"
  curl -sL -o "$dest" \
    -H "User-Agent: $UA" \
    --max-time 30 \
    --retry 3 \
    "$url" || echo "  [FAILED] $dir/$filename"
}

echo "=== American Yawp MS — Image Downloader ==="
echo ""

# --------------------------------------------------
# Chapter 1: Indigenous America (4 images — all present)
# --------------------------------------------------
echo "Chapter 1: Indigenous America"
download "ch1" "cahokia-mounds.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Monks_Mound_in_July.JPG/800px-Monks_Mound_in_July.JPG"
download "ch1" "mesa-verde.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Mesa_Verde_National_Park_Cliff_Palace_2006_09_12.jpg/800px-Mesa_Verde_National_Park_Cliff_Palace_2006_09_12.jpg"
download "ch1" "tenochtitlan.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Murales_Rivera_-_Markt_in_Tlatelolco_3.jpg/800px-Murales_Rivera_-_Markt_in_Tlatelolco_3.jpg"
download "ch1" "casta-painting.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Casta_painting_all.jpg/800px-Casta_painting_all.jpg"
echo ""

# --------------------------------------------------
# Chapter 2: Colliding Cultures (5 images — 1 present, 4 missing)
# --------------------------------------------------
echo "Chapter 2: Colliding Cultures"
download "ch2" "waldseemuller-map.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Waldseemuller_map_2.jpg/800px-Waldseemuller_map_2.jpg"
download "ch2" "de-bry-spanish-cruelty.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Kanibalismus_in_Brasilien_1557.jpg/800px-Kanibalismus_in_Brasilien_1557.jpg"
download "ch2" "champlain-habitation.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Habitation_de_Quebec.jpg/800px-Habitation_de_Quebec.jpg"
download "ch2" "secotan-village.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Village_of_Secotan.jpg/600px-Village_of_Secotan.jpg"
download "ch2" "negotiating-peace.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Benjamin-West-The-Death-of-General-Wolfe.jpg/800px-Benjamin-West-The-Death-of-General-Wolfe.jpg"
echo ""

# --------------------------------------------------
# Chapter 3: British North America (4 images — 1 present, 3 missing)
# --------------------------------------------------
echo "Chapter 3: British North America"
download "ch3" "pocahontas.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Simon_van_de_Passe_-_Pocahontas.jpg/600px-Simon_van_de_Passe_-_Pocahontas.jpg"
download "ch3" "mayflower-compact.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Mayflower_Compact_Bradford.jpg/600px-Mayflower_Compact_Bradford.jpg"
download "ch3" "slave-ship-brookes.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Slaveshipposter.jpg/600px-Slaveshipposter.jpg"
download "ch3" "old-plantation.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/The_Old_Plantation.jpg/800px-The_Old_Plantation.jpg"
echo ""

# --------------------------------------------------
# Chapter 4: Colonial Society (4 images — 1 present, 3 missing)
# --------------------------------------------------
echo "Chapter 4: Colonial Society"
download "ch4" "peale-family.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/CWPeale_The_Peale_Family.jpg/800px-CWPeale_The_Peale_Family.jpg"
download "ch4" "rice-cultivation.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Threshing_rice_in_South_Carolina.jpg/800px-Threshing_rice_in_South_Carolina.jpg"
download "ch4" "whitefield-preaching.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/George_Whitefield_preaching.jpg/600px-George_Whitefield_preaching.jpg"
download "ch4" "join-or-die.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/Benjamin_Franklin_-_Join_or_Die.jpg/800px-Benjamin_Franklin_-_Join_or_Die.jpg"
echo ""

# --------------------------------------------------
# Chapter 5: The American Revolution (5 images — 1 present, 4 missing)
# --------------------------------------------------
echo "Chapter 5: The American Revolution"
download "ch5" "boston-massacre.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Boston_Massacre_high-res.jpg/600px-Boston_Massacre_high-res.jpg"
download "ch5" "common-sense.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Common_Sense_%281776%29.jpg/500px-Common_Sense_%281776%29.jpg"
download "ch5" "declaration-of-independence.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Declaration_of_Independence_%281819%29%2C_by_John_Trumbull.jpg/800px-Declaration_of_Independence_%281819%29%2C_by_John_Trumbull.jpg"
download "ch5" "surrender-cornwallis.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Surrender_of_Lord_Cornwallis.jpg/800px-Surrender_of_Lord_Cornwallis.jpg"
download "ch5" "yorktown-soldiers.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Yorktown80.JPG/800px-Yorktown80.JPG"
echo ""

# --------------------------------------------------
# Chapter 6: A New Nation (8 images — all present)
# --------------------------------------------------
echo "Chapter 6: A New Nation"
download "ch6" "federal-pillars.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Eleventh_Pillar.jpg/600px-Eleventh_Pillar.jpg"
download "ch6" "shays-shattuck.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Shays%27_Rebellion.jpg/600px-Shays%27_Rebellion.jpg"
download "ch6" "independence-hall.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Independence_Hall_10.jpg/800px-Independence_Hall_10.jpg"
download "ch6" "madison.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/James_Madison.jpg/500px-James_Madison.jpg"
download "ch6" "hamilton.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Alexander_Hamilton_portrait_by_John_Trumbull_1806.jpg/500px-Alexander_Hamilton_portrait_by_John_Trumbull_1806.jpg"
download "ch6" "execution-louis-xvi.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Execution_of_Louis_XVI.jpg/800px-Execution_of_Louis_XVI.jpg"
download "ch6" "anti-jefferson-cartoon.jpeg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Jefferson-LOC.jpg/500px-Jefferson-LOC.jpg"
download "ch6" "us-capitol-1800.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/USCapitol1800.jpg/800px-USCapitol1800.jpg"
echo ""

# --------------------------------------------------
# Chapter 7: The Early Republic (16 images — 7 present, 9 missing)
# --------------------------------------------------
echo "Chapter 7: The Early Republic"
download "ch7" "america-guided-by-wisdom.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/America_guided_by_wisdom.jpg/800px-America_guided_by_wisdom.jpg"
download "ch7" "haitian-revolution.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Haitian_Revolution.jpg/800px-Haitian_Revolution.jpg"
download "ch7" "banneker-almanac.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Benjamin_Banneker%27s_Pennsylvania%2C_Delaware%2C_Maryland%2C_and_Virginia_Almanac_and_Ephemeris%2C_for_the_Year_of_Our_Lord_1795.jpg/500px-Benjamin_Banneker%27s_Pennsylvania%2C_Delaware%2C_Maryland%2C_and_Virginia_Almanac_and_Ephemeris%2C_for_the_Year_of_Our_Lord_1795.jpg"
download "ch7" "james-peale-family.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Jamespeale_family.jpg/800px-Jamespeale_family.jpg"
download "ch7" "camp-meeting.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Methodist_camp_meeting_%281819_engraving%29.jpg/800px-Methodist_camp_meeting_%281819_engraving%29.jpg"
download "ch7" "jefferson-banner.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Thomas_Jefferson_by_Rembrandt_Peale%2C_1800.jpg/500px-Thomas_Jefferson_by_Rembrandt_Peale%2C_1800.jpg"
download "ch7" "monticello.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Thomas_Jefferson%27s_Monticello.JPG/800px-Thomas_Jefferson%27s_Monticello.JPG"
download "ch7" "lewis-and-clark.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Lewis_and_Clark_Expedition.jpg/800px-Lewis_and_Clark_Expedition.jpg"
download "ch7" "john-marshall.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/John_Marshall_by_Henry_Inman%2C_1832.jpg/500px-John_Marshall_by_Henry_Inman%2C_1832.jpg"
download "ch7" "uss-chesapeake.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Chesapeakeleopard.jpg/800px-Chesapeakeleopard.jpg"
download "ch7" "red-jacket.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Red_Jacket_-_1828.jpg/500px-Red_Jacket_-_1828.jpg"
download "ch7" "tenskwatawa.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Tenskwatawa.jpg/500px-Tenskwatawa.jpg"
download "ch7" "british-indians-cartoon.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/A_scene_on_the_frontiers_as_practiced_by_the_humane_British_and_their_worthy_allies.jpg/800px-A_scene_on_the_frontiers_as_practiced_by_the_humane_British_and_their_worthy_allies.jpg"
download "ch7" "washington-burning.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/01/Burning_of_the_White_House_by_Tom_Freeman_%282004%29.jpg/800px-Burning_of_the_White_House_by_Tom_Freeman_%282004%29.jpg"
download "ch7" "battle-of-new-orleans.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Battle_of_New_Orleans.jpg/800px-Battle_of_New_Orleans.jpg"
download "ch7" "hartford-convention.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/TheHartfordConventionOrLeapNoLeap.jpg/800px-TheHartfordConventionOrLeapNoLeap.jpg"
echo ""

# --------------------------------------------------
# Chapter 8: The Market Revolution (4 images — 1 present, 3 missing)
# --------------------------------------------------
echo "Chapter 8: The Market Revolution"
download "ch8" "first-locomotive.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/DeWitt_Clinton_Locomotive_Replica.jpg/800px-DeWitt_Clinton_Locomotive_Replica.jpg"
download "ch8" "erie-canal.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Erie_Canal.jpg/800px-Erie_Canal.jpg"
download "ch8" "lowell-mills.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Boott_cotton_mills.jpg/800px-Boott_cotton_mills.jpg"
download "ch8" "south-street-nyc.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/South_Street_from_Maiden_Lane%2C_New_York_City.jpg/800px-South_Street_from_Maiden_Lane%2C_New_York_City.jpg"
echo ""

# --------------------------------------------------
# Chapter 9: Democracy in America (3 images — 1 present, 2 missing)
# --------------------------------------------------
echo "Chapter 9: Democracy in America"
download "ch9" "county-election.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/George_Caleb_Bingham_-_The_County_Election.jpg/800px-George_Caleb_Bingham_-_The_County_Election.jpg"
download "ch9" "andrew-jackson.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Andrew_jackson_head.jpg/500px-Andrew_jackson_head.jpg"
download "ch9" "trail-of-tears.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/Robert_Lindneux_-_The_Trail_of_Tears.jpg/800px-Robert_Lindneux_-_The_Trail_of_Tears.jpg"
echo ""

# --------------------------------------------------
# Chapter 10: Religion and Reform (5 images — 3 present, 2 missing)
# --------------------------------------------------
echo "Chapter 10: Religion and Reform"
download "ch10" "camp-meeting-revival.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/Camp_meeting.jpg/800px-Camp_meeting.jpg"
download "ch10" "frederick-douglass.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Frederick_Douglass_c1860s.jpg/500px-Frederick_Douglass_c1860s.jpg"
download "ch10" "seneca-falls.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Elizabeth_Cady_Stanton_and_Susan_B._Anthony.jpg/500px-Elizabeth_Cady_Stanton_and_Susan_B._Anthony.jpg"
download "ch10" "sojourner-truth.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Sojourner_Truth_c1870.jpg/500px-Sojourner_Truth_c1870.jpg"
download "ch10" "dorothea-dix.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Dorothea_Dix.jpg/500px-Dorothea_Dix.jpg"
echo ""

# --------------------------------------------------
# Chapter 11: The Cotton Revolution (4 images — 2 present, 2 missing)
# --------------------------------------------------
echo "Chapter 11: The Cotton Revolution"
download "ch11" "cotton-gin.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Cotton_gin_EWM_2007.jpg/800px-Cotton_gin_EWM_2007.jpg"
download "ch11" "slave-auction.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Slave_Auction_Ad.jpg/500px-Slave_Auction_Ad.jpg"
download "ch11" "slave-family.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/A_Slave_Family_in_the_Cotton_Field_near_Savannah%2C_Georgia%2C_from_Ballou%27s_Pictorial_Drawing-Room_Companion%2C_March_1858.jpg/800px-A_Slave_Family_in_the_Cotton_Field_near_Savannah%2C_Georgia%2C_from_Ballou%27s_Pictorial_Drawing-Room_Companion%2C_March_1858.jpg"
download "ch11" "slave-population-map.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Census-1860-Slave.jpg/800px-Census-1860-Slave.jpg"
echo ""

# --------------------------------------------------
# Chapter 12: Manifest Destiny (5 images — 2 present, 3 missing)
# --------------------------------------------------
echo "Chapter 12: Manifest Destiny"
download "ch12" "american-progress.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/American_Progress_%28John_Gast_painting%29.jpg/800px-American_Progress_%28John_Gast_painting%29.jpg"
download "ch12" "oregon-trail.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Emigrants_Crossing_the_Plains.jpg/800px-Emigrants_Crossing_the_Plains.jpg"
download "ch12" "battle-of-chapultepec.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Battle_of_Chapultepec%2C_13th_September_1847.jpg/800px-Battle_of_Chapultepec%2C_13th_September_1847.jpg"
download "ch12" "mexican-cession-map.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Mexican_Cession.png/800px-Mexican_Cession.png"
download "ch12" "gold-rush-miners.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/California_Gold_Rush_handbill.jpg/600px-California_Gold_Rush_handbill.jpg"
echo ""

# --------------------------------------------------
# Chapter 13: The Sectional Crisis (4 images — 2 present, 2 missing)
# --------------------------------------------------
echo "Chapter 13: The Sectional Crisis"
download "ch13" "uncle-toms-cabin.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/ElizaCrossestheIce.jpg/600px-ElizaCrossestheIce.jpg"
download "ch13" "bleeding-kansas.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Marais_des_Cygnes_massacre_of_May_19%2C_1858.jpg/800px-Marais_des_Cygnes_massacre_of_May_19%2C_1858.jpg"
download "ch13" "john-brown.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/John_Brown_by_Augustus_Washington%2C_1846-47.jpg/500px-John_Brown_by_Augustus_Washington%2C_1846-47.jpg"
download "ch13" "dred-scott.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Dred_Scott_photograph_%28circa_1857%29.jpg/500px-Dred_Scott_photograph_%28circa_1857%29.jpg"
download "ch13" "reynolds-political-map.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Reynolds%27s_Political_Map_of_the_United_States.jpg/800px-Reynolds%27s_Political_Map_of_the_United_States.jpg"
echo ""

# --------------------------------------------------
# Chapter 14: The Civil War (5 images — 2 present, 3 missing)
# --------------------------------------------------
echo "Chapter 14: The Civil War"
download "ch14" "fort-sumter.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Ft_Sumter_bombardment_1861.jpg/800px-Ft_Sumter_bombardment_1861.jpg"
download "ch14" "soldier-family.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/Unidentified_African_American_soldier_in_Union_uniform_with_wife_and_two_daughters.jpg/500px-Unidentified_African_American_soldier_in_Union_uniform_with_wife_and_two_daughters.jpg"
download "ch14" "usct-soldiers.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/USCT1.jpg/600px-USCT1.jpg"
download "ch14" "antietam-dead.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Bodies_on_the_battlefield_at_antietam.jpg/800px-Bodies_on_the_battlefield_at_antietam.jpg"
download "ch14" "field-hospital.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Zouaves_at_Antietam_field_hospital.jpg/800px-Zouaves_at_Antietam_field_hospital.jpg"
echo ""

# --------------------------------------------------
# Chapter 15: Reconstruction (5 images — 3 present, 2 missing)
# --------------------------------------------------
echo "Chapter 15: Reconstruction"
download "ch15" "contrabands.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Cumberland_Landing%2C_Va._Group_of_%22contrabands%22_at_Foller%27s_house_-_NARA_-_529312.jpg/800px-Cumberland_Landing%2C_Va._Group_of_%22contrabands%22_at_Foller%27s_house_-_NARA_-_529312.jpg"
download "ch15" "fifteenth-amendment.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/15th-amendment-celebration-1870.jpg/600px-15th-amendment-celebration-1870.jpg"
download "ch15" "reconstruction-congress.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/First_Colored_Senator_and_Representatives.jpg/800px-First_Colored_Senator_and_Representatives.jpg"
download "ch15" "freedmens-bureau.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Freedmen%27s_bureau.jpg/800px-Freedmen%27s_bureau.jpg"
download "ch15" "kkk-cartoon.jpg" \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Klan-in-a-carpet-bag.jpg/500px-Klan-in-a-carpet-bag.jpg"
echo ""

echo "=== Done ==="
echo ""
echo "Check for any [FAILED] messages above."
echo "All images are from Wikimedia Commons (public domain / CC-licensed)."
echo ""
echo "Total images tracked: 82"
echo "Run this script again to retry any failed downloads."
