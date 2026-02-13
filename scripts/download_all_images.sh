#!/usr/bin/env bash
# Download all chapter images
# Runs each per-chapter download script in sequence.
# Usage: bash scripts/download_all_images.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "============================================"
echo "  American Yawp MS — Image Downloader"
echo "============================================"
echo ""

FAIL_COUNT=0

for ch in 1 2 3 4 5 7 8 9 10 11 12 13 14 15; do
  script="$SCRIPT_DIR/download_ch${ch}_images.sh"
  if [ -f "$script" ]; then
    echo "--- Chapter $ch ---"
    bash "$script" || FAIL_COUNT=$((FAIL_COUNT + 1))
    echo ""
  else
    echo "--- Chapter $ch --- [no script found, skipping]"
  fi
done

echo "============================================"
if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "  Done with $FAIL_COUNT chapter(s) reporting failures."
  echo "  Check output above for [FAILED] lines."
else
  echo "  All downloads complete."
fi
echo "============================================"
echo ""
echo "Note: Chapter 6 images are already committed to the repository."
