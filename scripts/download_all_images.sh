#!/usr/bin/env bash
# Download all chapter images (ch1–ch15).
# Runs each per-chapter script in sequence. Skips already-downloaded files;
# each chapter script works around per-file errors and continues.
# Usage: bash scripts/download_all_images.sh

set -u
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FAILED_LIST=()

echo "============================================"
echo "  American Yawp MS — Image Downloader"
echo "============================================"
echo "  (Skips existing files; continues on errors)"
echo ""

FAIL_COUNT=0
# Do not exit on chapter script failure so we run all chapters
set +e
for ch in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
  script="$SCRIPT_DIR/download_ch${ch}_images.sh"
  if [ -f "$script" ]; then
    echo "--- Chapter $ch ---"
    output=$(bash "$script" 2>&1)
    script_exit=$?
    echo "$output"
    while IFS= read -r line; do
      if [[ "$line" == *"[FAILED]"* ]]; then
        FAILED_LIST+=("Chapter $ch: $line")
      fi
    done <<< "$output"
    [ "$script_exit" -ne 0 ] && FAIL_COUNT=$((FAIL_COUNT + 1))
    echo ""
  else
    echo "--- Chapter $ch --- [no script found, skipping]"
  fi
done
set -e

echo "============================================"
if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "  Done. $FAIL_COUNT chapter(s) had failures (see [FAILED] above)."
  echo "  Re-run this script to retry; existing files are skipped."
else
  echo "  All chapter image scripts completed."
fi
echo "============================================"

if [ ${#FAILED_LIST[@]} -gt 0 ]; then
  echo ""
  echo "--------------------------------------------"
  echo "  Failed images (for retry or manual check):"
  echo "--------------------------------------------"
  printf '  %s\n' "${FAILED_LIST[@]}"
  echo "--------------------------------------------"
fi

echo ""
echo "For maps (Beringia, 13 colonies, triangular trade, Yorktown, US 1789,"
echo "Louisiana Purchase, canals, Trail of Tears, UGRR, Civil War, Reconstruction),"
echo "run:  bash scripts/download_all_maps.sh"
