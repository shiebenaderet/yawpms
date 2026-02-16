#!/bin/bash
# Download primary source images from Wikimedia Commons
# Run this script from the primary-sources/ directory:
#   cd primary-sources && bash download-images.sh
#
# All images are public domain (pre-1929 or US government works).

set -e
mkdir -p images

echo "Downloading primary source images..."

# Ch1 Source 1.2 — Monks Mound, Cahokia (McAdams 1882 illustration)
echo "[1/13] Monks Mound illustration..."
curl -sL -o images/ch1-monks-mound.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Monks_Mound_in_July.jpg/800px-Monks_Mound_in_July.jpg"

# Ch1 Source 1.4 — Algonquin Birch Bark Container (Smithsonian NMAI)
echo "[2/13] Birch bark container..."
curl -sL -o images/ch1-birch-bark.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Birch_Bark_Basket%2C_Abenaki_-_Peabody_Museum_Harvard.jpg/800px-Birch_Bark_Basket%2C_Abenaki_-_Peabody_Museum_Harvard.jpg"

# Ch2 Source 2.3 — De Bry, Columbus Landing on Hispaniola (1594)
echo "[3/13] Columbus landing engraving..."
curl -sL -o images/ch2-columbus-landing.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/4/48/Columbus_landing_on_Hispaniola.JPG"

# Ch3 Source 3.3 — Pocahontas by Simon van de Passe (1616)
echo "[4/13] Pocahontas engraving..."
curl -sL -o images/ch3-pocahontas.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Pocahontas_by_Simon_van_de_Passe.jpg/600px-Pocahontas_by_Simon_van_de_Passe.jpg"

# Ch4 Source 4.2 — Benjamin Franklin, "Join, or Die" (1754)
echo "[5/13] Join, or Die cartoon..."
curl -sL -o images/ch4-join-or-die.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/Benjamin_Franklin_-_Join_or_Die.jpg/800px-Benjamin_Franklin_-_Join_or_Die.jpg"

# Ch6 Source 6.4 — "The Providential Detection" (c. 1800)
echo "[6/13] Providential Detection cartoon..."
curl -sL -o images/ch6-providential-detection.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/2/2b/The_Providential_Detection.jpg"

# Ch7 Source 7.4 — Bombardment of Fort McHenry (Bower, c. 1814)
echo "[7/13] Fort McHenry bombardment..."
curl -sL -o images/ch7-fort-mchenry.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Ft._Henry_bombardridge_1814.jpg/800px-Ft._Henry_bombardridge_1814.jpg"

# Ch8 Source 8.4 — View of the Erie Canal (John William Hill, 1829)
echo "[8/13] Erie Canal view..."
curl -sL -o images/ch8-erie-canal.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Erie_Canal.jpg/800px-Erie_Canal.jpg"

# Ch9 Source 9.4 — Cherokee Phoenix Newspaper Masthead (1828)
echo "[9/13] Cherokee Phoenix masthead..."
curl -sL -o images/ch9-cherokee-phoenix.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Cherokee_phoenix.jpg/800px-Cherokee_phoenix.jpg"

# Ch11 Source 11.3 — Slave Trader Broadside
echo "[10/13] Slave trader broadside..."
curl -sL -o images/ch11-slave-broadside.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/Slavetradeposter.jpg/600px-Slavetradeposter.jpg"

# Ch12 Source 12.3 — "American Progress" by John Gast (1872)
echo "[11/13] American Progress painting..."
curl -sL -o images/ch12-american-progress.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/American_Progress_%28John_Gast_painting%29.jpg/800px-American_Progress_%28John_Gast_painting%29.jpg"

# Ch14 Source 14.4 — Contraband Camp, Richmond (c. 1865)
echo "[12/13] Contraband camp photograph..."
curl -sL -o images/ch14-contraband-camp.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Contraband_camp_Richmand_Virginia.jpg/800px-Contraband_camp_Richmand_Virginia.jpg"

# Ch15 Source 15.4 — Thomas Nast, "Worse Than Slavery" (1874)
echo "[13/13] Worse Than Slavery cartoon..."
curl -sL -o images/ch15-worse-than-slavery.jpg \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Worse_than_Slavery_%281874%29%2C_by_Thomas_Nast.jpg/600px-Worse_than_Slavery_%281874%29%2C_by_Thomas_Nast.jpg"

echo ""
echo "Done! Downloaded 13 images to primary-sources/images/"
echo ""
echo "Image sources (all public domain):"
echo "  - Wikimedia Commons (various contributors)"
echo "  - Library of Congress"
echo "  - National Archives"
echo ""
echo "If any download failed, check the URL — Wikimedia may have"
echo "renamed the file. Search commons.wikimedia.org for the title."
