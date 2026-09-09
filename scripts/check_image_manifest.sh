#!/usr/bin/env bash
# Fails when an image is referenced without a provenance record, when a manifest entry
# names a file that is not on disk, or when a primary-source image is orphaned.
# Usage: bash scripts/check_image_manifest.sh
set -uo pipefail
cd "$(cd "$(dirname "$0")" && pwd)/.."
command -v node >/dev/null || { echo "node is required" >&2; exit 1; }
exec node scripts/check_image_manifest.js
