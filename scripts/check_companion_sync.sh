#!/usr/bin/env bash
# Fails when a companion resource has drifted from the chapters.
#   1. a chapter .vocab-box term missing from the VOCAB deck
#   2. a chapter absent from QUIZZES, VOCAB or SLIDES
#   3. a timeline anchor pointing at an id that does not exist
# Usage: bash scripts/check_companion_sync.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."
command -v node >/dev/null || { echo "node is required" >&2; exit 1; }
exec node scripts/check_companion_sync.js
