#!/bin/bash
# Download images for American Yawp Jr. Chapter 6
# Run from the project root: bash scripts/download_ch6_images.sh

set -e
mkdir -p images/ch6
cd images/ch6

echo "Downloading Chapter 6 images..."

BASE="http://www.americanyawp.com/text/wp-content/uploads"

curl -L -o "federal-pillars.jpg" "$BASE/cropped2federalpillars-newyork-2.jpg"
echo "  ✓ federal-pillars.jpg"

curl -L -o "shays-shattuck.jpg" "$BASE/Unidentified_Artist_-_Daniel_Shays_and_Job_Shattuck_-_Google_Art_Project.jpg"
echo "  ✓ shays-shattuck.jpg"

curl -L -o "independence-hall.jpg" "$BASE/Independence_Hall_10.jpg"
echo "  ✓ independence-hall.jpg"

curl -L -o "madison.jpg" "$BASE/Madison_1816.jpg"
echo "  ✓ madison.jpg"

curl -L -o "hamilton.jpg" "$BASE/hamilton_1806.jpg"
echo "  ✓ hamilton.jpg"

curl -L -o "execution-louis-xvi.jpg" "$BASE/Execution_of_Louis_XVI.jpg"
echo "  ✓ execution-louis-xvi.jpg"

curl -L -o "anti-jefferson-cartoon.jpeg" "$BASE/server.np-2-1-1000x1166.jpeg"
echo "  ✓ anti-jefferson-cartoon.jpeg"

curl -L -o "us-capitol-1800.jpg" "$BASE/USCapitol1800.jpg"
echo "  ✓ us-capitol-1800.jpg"

echo ""
echo "Done! Downloaded $(ls | wc -l) images to images/ch6/"
ls -lh
