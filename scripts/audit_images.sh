#!/usr/bin/env bash
# ============================================================
#  audit_images.sh — Comprehensive image & map audit  (v2.0)
# ============================================================
#  Checks every image referenced in HTML against the filesystem,
#  cross-references download scripts for recovery URLs, finds
#  name mismatches and orphaned files, and reports alt text gaps.
#
#  New in v2.0:
#    - Version tracking in JSON output
#    - --download flag: generate a ready-to-run download script
#    - --fix-names flag: auto-rename disk files that mismatch
#    - --clean flag: remove orphaned files
#    - Wikimedia Commons API fallback for images without URLs
#    - download-commands.sh generation for missing images
#
#  Usage:
#    bash scripts/audit_images.sh              # audit only
#    bash scripts/audit_images.sh --download   # audit + emit download script
#    bash scripts/audit_images.sh --fix-names  # audit + rename mismatches
#    bash scripts/audit_images.sh --clean      # audit + remove orphans
#    bash scripts/audit_images.sh --all        # all of the above
# ============================================================

AUDIT_VERSION="2.0"

set -eo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REPORT="$ROOT/audit-results.json"
DOWNLOAD_SCRIPT="$ROOT/scripts/download-missing.sh"

# ── Parse flags ──────────────────────────────────────────────
DO_DOWNLOAD=false
DO_FIXNAMES=false
DO_CLEAN=false
for arg in "$@"; do
  case "$arg" in
    --download)   DO_DOWNLOAD=true  ;;
    --fix-names)  DO_FIXNAMES=true  ;;
    --clean)      DO_CLEAN=true     ;;
    --all)        DO_DOWNLOAD=true; DO_FIXNAMES=true; DO_CLEAN=true ;;
    --help|-h)
      echo "Usage: bash scripts/audit_images.sh [--download] [--fix-names] [--clean] [--all]"
      exit 0
      ;;
  esac
done

# Colours (no-op if piped)
if [ -t 1 ]; then
  RED='\033[0;31m'; GRN='\033[0;32m'; YEL='\033[0;33m'
  CYN='\033[0;36m'; BLD='\033[1m'; RST='\033[0m'
else
  RED=''; GRN=''; YEL=''; CYN=''; BLD=''; RST=''
fi

# ── Temp files ───────────────────────────────────────────────
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

HTML_REFS="$TMP_DIR/html_refs.txt"       # file:line:imgpath
UNIQUE_REFS="$TMP_DIR/unique_refs.txt"   # sorted unique image paths
DISK_FILES="$TMP_DIR/disk_files.txt"     # all images on disk (relative)
SCRIPT_URLS="$TMP_DIR/script_urls.txt"   # filename\turl
MISSING_FILE="$TMP_DIR/missing.txt"
ORPHAN_FILE="$TMP_DIR/orphan.txt"
MISMATCH_FILE="$TMP_DIR/mismatch.txt"

echo ""
echo -e "${BLD}============================================${RST}"
echo -e "${BLD}  Image & Map Audit — American Yawp MS${RST}"
echo -e "${BLD}  Version $AUDIT_VERSION${RST}"
echo -e "${BLD}============================================${RST}"
echo ""

# ═══════════════════════════════════════════════════════════════
#  PHASE 1 — Collect every image reference from HTML
# ═══════════════════════════════════════════════════════════════
echo -e "${CYN}Phase 1: Scanning HTML files for image references...${RST}"

> "$HTML_REFS"

# 1a) <img src="..."> in root HTML files
for f in "$ROOT"/*.html; do
  [ -f "$f" ] || continue
  fname=$(basename "$f")
  { grep -on 'src="[^"]*"' "$f" || true; } | while IFS=: read -r linenum match; do
    imgpath=$(echo "$match" | sed 's/^src="//;s/"$//')
    case "$imgpath" in
      *.jpg|*.jpeg|*.png|*.gif|*.svg|*.webp)
        echo "$fname:$linenum:$imgpath" >> "$HTML_REFS"
        ;;
    esac
  done
done

# 1b) <img src="..."> in primary-sources/ HTML files
for f in "$ROOT"/primary-sources/*.html; do
  [ -f "$f" ] || continue
  fname="primary-sources/$(basename "$f")"
  { grep -on 'src="[^"]*"' "$f" || true; } | while IFS=: read -r linenum match; do
    imgpath=$(echo "$match" | sed 's/^src="//;s/"$//')
    case "$imgpath" in
      *.jpg|*.jpeg|*.png|*.gif|*.svg|*.webp)
        echo "$fname:$linenum:primary-sources/$imgpath" >> "$HTML_REFS"
        ;;
    esac
  done
done

# 1c) background-image: url('...') in HTML inline styles
for f in "$ROOT"/*.html; do
  [ -f "$f" ] || continue
  fname=$(basename "$f")
  { grep -on "url('[^']*')" "$f" || true; } | while IFS=: read -r linenum match; do
    imgpath=$(echo "$match" | sed "s/^url('//;s/')$//")
    case "$imgpath" in
      *.jpg|*.jpeg|*.png|*.gif|*.svg|*.webp)
        echo "$fname:$linenum:$imgpath" >> "$HTML_REFS"
        ;;
    esac
  done
done

# 1d) url('...') in CSS files (resolve ../images/ to images/)
for f in "$ROOT"/css/*.css; do
  [ -f "$f" ] || continue
  fname="css/$(basename "$f")"
  { grep -on "url('[^']*')" "$f" || true; } | while IFS=: read -r linenum match; do
    imgpath=$(echo "$match" | sed "s/^url('//;s/')$//;s|^\.\./||")
    case "$imgpath" in
      *.jpg|*.jpeg|*.png|*.gif|*.svg|*.webp)
        echo "$fname:$linenum:$imgpath" >> "$HTML_REFS"
        ;;
    esac
  done
done

total_raw=$(wc -l < "$HTML_REFS")
echo -e "  Found $total_raw raw image references"

# Extract unique image paths
cut -d: -f3- "$HTML_REFS" | sort -u > "$UNIQUE_REFS"
total_unique=$(wc -l < "$UNIQUE_REFS")
echo -e "  $total_unique unique image paths"

# ═══════════════════════════════════════════════════════════════
#  PHASE 2 — Build disk inventory
# ═══════════════════════════════════════════════════════════════
echo -e "${CYN}Phase 2: Inventorying image files on disk...${RST}"

> "$DISK_FILES"

# Chapter + site images
find "$ROOT/images" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.svg' -o -iname '*.webp' \) \
  | sed "s|^$ROOT/||" | sort >> "$DISK_FILES"

# Primary source images
if [ -d "$ROOT/primary-sources/images" ]; then
  find "$ROOT/primary-sources/images" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.svg' -o -iname '*.webp' \) \
    | sed "s|^$ROOT/||" | sort >> "$DISK_FILES"
fi

disk_count=$(wc -l < "$DISK_FILES")
echo -e "  $disk_count image files on disk"

# ═══════════════════════════════════════════════════════════════
#  PHASE 3 — Extract download URLs from scripts
# ═══════════════════════════════════════════════════════════════
echo -e "${CYN}Phase 3: Extracting download URLs from scripts...${RST}"

> "$SCRIPT_URLS"
for script in "$ROOT"/scripts/download_ch*_images.sh "$ROOT"/scripts/download_primary_source_images.sh "$ROOT"/scripts/download_all_maps.sh; do
  [ -f "$script" ] || continue
  sname=$(basename "$script")
  { grep -o '\["[^"]*"\]="[^"]*"' "$script" 2>/dev/null || true; } | while read -r pair; do
    filename=$(echo "$pair" | sed 's/\[\"//;s/\"\]=\".*$//')
    url=$(echo "$pair" | sed 's/.*\]=\"//;s/\"$//')
    echo -e "$filename\t$url\t$sname" >> "$SCRIPT_URLS"
  done
done

# Also extract "download N filename url" patterns from download_all_maps.sh
if [ -f "$ROOT/scripts/download_all_maps.sh" ]; then
  { grep '^download ' "$ROOT/scripts/download_all_maps.sh" 2>/dev/null || true; } | while read -r _ chnum fname url; do
    fname=$(echo "$fname" | tr -d '"')
    url=$(echo "$url" | tr -d '"')
    [ -n "$fname" ] && [ -n "$url" ] && echo -e "$fname\t$url\tdownload_all_maps.sh" >> "$SCRIPT_URLS"
  done
fi

script_count=$(wc -l < "$SCRIPT_URLS")
echo -e "  $script_count declared downloads across all scripts"

# ═══════════════════════════════════════════════════════════════
#  PHASE 4 — Cross-reference: HTML refs vs disk
# ═══════════════════════════════════════════════════════════════
echo -e "${CYN}Phase 4: Cross-referencing HTML refs vs disk files...${RST}"

FOUND=0
MISSING=0
> "$MISSING_FILE"
> "$MISMATCH_FILE"

while IFS='' read -r img_path; do
  full_path="$ROOT/$img_path"

  if [ -f "$full_path" ]; then
    FOUND=$((FOUND + 1))
  else
    MISSING=$((MISSING + 1))

    # Gather sources
    sources=$(grep ":${img_path}$" "$HTML_REFS" | cut -d: -f1-2 | paste -sd', ' - || echo "unknown")
    basename_img=$(basename "$img_path")
    dir_img=$(dirname "$img_path")

    # Method 1: Download URL from scripts (exact filename match)
    script_url=$(grep "^${basename_img}	" "$SCRIPT_URLS" | head -1 | cut -f2 || true)
    script_name=$(grep "^${basename_img}	" "$SCRIPT_URLS" | head -1 | cut -f3 || true)

    # Method 2: Same name, different extension
    diff_ext=""
    stem="${basename_img%.*}"
    for ext in jpg jpeg png gif svg webp; do
      alt_name="${stem}.${ext}"
      if [ -f "$ROOT/$dir_img/$alt_name" ] && [ "$alt_name" != "$basename_img" ]; then
        diff_ext="$alt_name"
        break
      fi
    done

    # Method 3: Similar names in same directory (strip -map suffix, etc.)
    similar=""
    if [ -d "$ROOT/$dir_img" ]; then
      search_stem=$(echo "$stem" | sed 's/-map$//;s/-1[0-9][0-9][0-9]$//')
      for candidate in "$ROOT/$dir_img"/*; do
        [ -f "$candidate" ] || continue
        cand_name=$(basename "$candidate")
        cand_stem="${cand_name%.*}"
        cand_search=$(echo "$cand_stem" | sed 's/-map$//;s/-1[0-9][0-9][0-9]$//')
        if [ "$cand_name" != "$basename_img" ] && [ "$cand_search" = "$search_stem" ]; then
          similar="$cand_name"
          break
        fi
      done
      # If no exact stem match, try substring
      if [ -z "$similar" ]; then
        for candidate in "$ROOT/$dir_img"/*; do
          [ -f "$candidate" ] || continue
          cand_name=$(basename "$candidate")
          if [ "$cand_name" != "$basename_img" ] && echo "$cand_name" | grep -qi "$search_stem" 2>/dev/null; then
            similar="$cand_name"
            break
          fi
        done
      fi
    fi

    # Method 4: Check download_all_maps.sh for URL by partial name match
    maps_url=""
    if [ -z "$script_url" ]; then
      maps_url=$(grep -i "$stem" "$SCRIPT_URLS" | head -1 | cut -f2 || true)
    fi

    # Method 5: Try Wikimedia Commons API (filename heuristic)
    wiki_url=""
    if [ -z "$script_url" ] && [ -z "$maps_url" ]; then
      # Build a search-friendly name from the filename
      wiki_search=$(echo "$stem" | sed 's/-/ /g;s/_/ /g;s/map$//;s/  / /g' | sed 's/^ *//;s/ *$//')
      # Only attempt if curl is available and we have a reasonable search term
      if command -v curl >/dev/null 2>&1 && [ ${#wiki_search} -gt 3 ]; then
        wiki_result=$(curl -s --max-time 5 \
          "https://commons.wikimedia.org/w/api.php?action=query&list=search&srsearch=${wiki_search// /+}&srnamespace=6&srlimit=1&format=json" 2>/dev/null || true)
        wiki_title=$(echo "$wiki_result" | grep -o '"title":"File:[^"]*"' | head -1 | sed 's/"title":"File://;s/"//' || true)
        if [ -n "$wiki_title" ]; then
          wiki_url="https://commons.wikimedia.org/wiki/Special:FilePath/${wiki_title// /_}?width=800"
        fi
      fi
    fi

    # Classify type
    img_type="photo"
    if [[ "$img_path" == *map* ]] || [[ "$img_path" == *-map.* ]]; then
      img_type="map"
    elif [[ "$img_path" == primary-sources/* ]]; then
      img_type="primary-source"
    fi

    # Record: type|path|sources|script_url|diff_ext|similar|maps_url|script_name|wiki_url
    echo "${img_type}|${img_path}|${sources}|${script_url:-}|${diff_ext:-}|${similar:-}|${maps_url:-}|${script_name:-}|${wiki_url:-}" >> "$MISSING_FILE"

    # Check for name mismatch
    if [ -n "$diff_ext" ] || [ -n "$similar" ]; then
      candidate="${diff_ext:-$similar}"
      echo "$img_path|$dir_img/$candidate" >> "$MISMATCH_FILE"
    fi
  fi
done < "$UNIQUE_REFS"

MISMATCH_COUNT=$(wc -l < "$MISMATCH_FILE")

# ═══════════════════════════════════════════════════════════════
#  PHASE 5 — Find orphaned files (on disk but never referenced)
# ═══════════════════════════════════════════════════════════════
echo -e "${CYN}Phase 5: Finding orphaned files on disk...${RST}"

ORPHANS=0
> "$ORPHAN_FILE"

while IFS='' read -r disk_file; do
  if ! grep -qxF "$disk_file" "$UNIQUE_REFS" 2>/dev/null; then
    size=$(stat -c%s "$ROOT/$disk_file" 2>/dev/null || echo "0")
    kb=$(( size / 1024 ))
    echo "$disk_file|${kb}KB" >> "$ORPHAN_FILE"
    ORPHANS=$((ORPHANS + 1))
  fi
done < "$DISK_FILES"

# ═══════════════════════════════════════════════════════════════
#  PHASE 6 — Alt text audit
# ═══════════════════════════════════════════════════════════════
echo -e "${CYN}Phase 6: Auditing alt text...${RST}"

ALT_TOTAL=0
ALT_PRESENT=0
ALT_EMPTY=0

for f in "$ROOT"/*.html "$ROOT"/primary-sources/*.html; do
  [ -f "$f" ] || continue
  count=$(grep -c '<img ' "$f" 2>/dev/null || true)
  count=${count:-0}; count=${count// /}
  ALT_TOTAL=$((ALT_TOTAL + count))

  present=$(grep -c 'alt="[^"]' "$f" 2>/dev/null || true)
  present=${present:-0}; present=${present// /}
  ALT_PRESENT=$((ALT_PRESENT + present))

  empty=$(grep -c 'alt=""' "$f" 2>/dev/null || true)
  empty=${empty:-0}; empty=${empty// /}
  ALT_EMPTY=$((ALT_EMPTY + empty))
done

ALT_NONE=$((ALT_TOTAL - ALT_PRESENT - ALT_EMPTY))

# ═══════════════════════════════════════════════════════════════
#  PHASE 7 — Print report
# ═══════════════════════════════════════════════════════════════
echo ""
echo -e "${BLD}============================================${RST}"
echo -e "${BLD}  AUDIT RESULTS${RST}"
echo -e "${BLD}============================================${RST}"
echo ""

echo -e "${BLD}Overview:${RST}"
echo -e "  Total unique image references:  $total_unique"
echo -e "  Found on disk:                  ${GRN}$FOUND${RST}"
echo -e "  Missing from disk:              ${RED}$MISSING${RST}"
echo -e "  Name-mismatch candidates:       ${YEL}$MISMATCH_COUNT${RST}"
echo -e "  Orphaned files (unreferenced):  ${YEL}$ORPHANS${RST}"
echo ""
echo -e "${BLD}Alt Text:${RST}"
echo -e "  Total <img> tags:           $ALT_TOTAL"
echo -e "  With descriptive alt text:  ${GRN}$ALT_PRESENT${RST}"
echo -e "  With empty alt=\"\":          ${YEL}$ALT_EMPTY${RST}"
echo -e "  Missing alt attribute:      ${RED}$ALT_NONE${RST}"
echo ""

# --- Missing images detail ---
if [ -s "$MISSING_FILE" ]; then
  map_count=$(grep '^map|' "$MISSING_FILE" | wc -l)
  photo_count=$(grep '^photo|' "$MISSING_FILE" | wc -l)
  ps_count=$(grep '^primary-source|' "$MISSING_FILE" | wc -l)

  echo -e "${BLD}${RED}MISSING IMAGES ($MISSING total):${RST}"
  echo -e "  Maps:             $map_count"
  echo -e "  Photos:           $photo_count"
  echo -e "  Primary Sources:  $ps_count"
  echo ""

  # Print missing maps
  if [ "$map_count" -gt 0 ]; then
    echo -e "  ${BLD}── Missing Maps ($map_count) ──${RST}"
    echo ""
    grep '^map|' "$MISSING_FILE" | sort -t'|' -k2 | while IFS='|' read -r type path sources url diffext similar mapsurl scriptname wikiurl; do
      echo -e "    ${RED}✗${RST} $path"
      echo -e "      Referenced by: $sources"
      if [ -n "$url" ]; then
        echo -e "      ${GRN}✓ Download URL (${scriptname}):${RST} $url"
      elif [ -n "$mapsurl" ]; then
        echo -e "      ${GRN}✓ Partial URL match:${RST} $mapsurl"
      elif [ -n "$wikiurl" ]; then
        echo -e "      ${CYN}? Wikimedia API suggestion:${RST} $wikiurl"
      else
        echo -e "      ${RED}✗ No download URL found${RST}"
      fi
      if [ -n "$similar" ]; then
        echo -e "      ${YEL}→ Similar file on disk:${RST} $similar"
      fi
      if [ -n "$diffext" ]; then
        echo -e "      ${YEL}→ Same name, different ext:${RST} $diffext"
      fi
      echo ""
    done
  fi

  # Print missing photos
  if [ "$photo_count" -gt 0 ]; then
    echo -e "  ${BLD}── Missing Photos ($photo_count) ──${RST}"
    echo ""
    grep '^photo|' "$MISSING_FILE" | sort -t'|' -k2 | while IFS='|' read -r type path sources url diffext similar mapsurl scriptname wikiurl; do
      echo -e "    ${RED}✗${RST} $path"
      echo -e "      Referenced by: $sources"
      if [ -n "$url" ]; then
        echo -e "      ${GRN}✓ Download URL (${scriptname}):${RST} $url"
      elif [ -n "$wikiurl" ]; then
        echo -e "      ${CYN}? Wikimedia API suggestion:${RST} $wikiurl"
      else
        echo -e "      ${RED}✗ No download URL found${RST}"
      fi
      if [ -n "$similar" ]; then
        echo -e "      ${YEL}→ Similar file on disk:${RST} $similar"
      fi
      echo ""
    done
  fi

  # Print missing primary source images
  if [ "$ps_count" -gt 0 ]; then
    echo -e "  ${BLD}── Missing Primary Source Images ($ps_count) ──${RST}"
    echo ""
    grep '^primary-source|' "$MISSING_FILE" | sort -t'|' -k2 | while IFS='|' read -r type path sources url diffext similar mapsurl scriptname wikiurl; do
      echo -e "    ${RED}✗${RST} $path"
      echo -e "      Referenced by: $sources"
      if [ -n "$url" ]; then
        echo -e "      ${GRN}✓ Download URL (${scriptname}):${RST} $url"
      elif [ -n "$wikiurl" ]; then
        echo -e "      ${CYN}? Wikimedia API suggestion:${RST} $wikiurl"
      else
        echo -e "      ${RED}✗ No download URL found${RST}"
      fi
      echo ""
    done
  fi
fi

# --- Orphaned files ---
if [ -s "$ORPHAN_FILE" ]; then
  echo -e "${BLD}${YEL}ORPHANED FILES ($ORPHANS):${RST}"
  echo -e "  (On disk but not referenced in any HTML file)"
  echo ""
  while IFS='|' read -r path size; do
    echo -e "    ${YEL}?${RST} $path  ($size)"
  done < "$ORPHAN_FILE"
  echo ""
fi

# --- Name mismatches ---
if [ -s "$MISMATCH_FILE" ]; then
  echo -e "${BLD}${YEL}LIKELY NAME MISMATCHES ($MISMATCH_COUNT):${RST}"
  echo -e "  (Missing file has a similar file on disk — possible rename fix)"
  echo ""
  while IFS='|' read -r missing candidate; do
    echo -e "    ${RED}✗${RST} HTML wants: $missing"
    echo -e "    ${GRN}→${RST} Disk has:   $candidate"
    echo ""
  done < "$MISMATCH_FILE"
fi

# ═══════════════════════════════════════════════════════════════
#  PHASE 8 — Generate JSON report
# ═══════════════════════════════════════════════════════════════
echo -e "${CYN}Writing JSON report to audit-results.json...${RST}"

{
echo '{'
echo "  \"audit_version\": \"$AUDIT_VERSION\","
echo '  "audit_date": "'$(date +%Y-%m-%d)'",'
echo '  "summary": {'
echo "    \"total_references\":      $total_unique,"
echo "    \"found_on_disk\": $FOUND,"
echo "    \"missing\": $MISSING,"
echo "    \"orphaned\": $ORPHANS,"
echo "    \"name_mismatches\":        $MISMATCH_COUNT,"
echo '    "alt_text": {'
echo "      \"total_img_tags\": $ALT_TOTAL,"
echo "      \"with_alt\": $ALT_PRESENT,"
echo "      \"empty_alt\": $ALT_EMPTY,"
echo "      \"missing_alt\": $ALT_NONE"
echo '    }'
echo '  },'

# Missing images array
echo '  "missing_images": ['
if [ -s "$MISSING_FILE" ]; then
  first=1
  while IFS='|' read -r type path sources url diffext similar mapsurl scriptname wikiurl; do
    [ "$first" -eq 1 ] && first=0 || echo ','
    effective_url="${url:-${mapsurl:-${wikiurl:-null}}}"
    [ "$effective_url" = "null" ] || effective_url="\"$effective_url\""
    url_source="null"
    if [ -n "$url" ]; then
      url_source="\"script:${scriptname}\""
    elif [ -n "$mapsurl" ]; then
      url_source="\"partial-match\""
    elif [ -n "$wikiurl" ]; then
      url_source="\"wikimedia-api\""
    fi
    similar_val="${similar:-${diffext:-null}}"
    [ "$similar_val" = "null" ] || similar_val="\"$similar_val\""
    echo -n "    { \"type\": \"$type\", \"path\": \"$path\", \"referenced_by\": \"$(echo "$sources" | sed 's/"/\\"/g')\", \"download_url\": $effective_url, \"url_source\": $url_source, \"similar_on_disk\": $similar_val }"
  done < "$MISSING_FILE"
  echo ''
fi
echo '  ],'

# Orphaned files array
echo '  "orphaned_files": ['
if [ -s "$ORPHAN_FILE" ]; then
  first=1
  while IFS='|' read -r path size; do
    [ "$first" -eq 1 ] && first=0 || echo ','
    echo -n "    \"$path\""
  done < "$ORPHAN_FILE"
  echo ''
fi
echo '  ],'

# Name mismatches array
echo '  "name_mismatches": ['
if [ -s "$MISMATCH_FILE" ]; then
  first=1
  while IFS='|' read -r missing candidate; do
    [ "$first" -eq 1 ] && first=0 || echo ','
    echo -n "    { \"html_wants\": \"$missing\", \"disk_has\": \"$candidate\" }"
  done < "$MISMATCH_FILE"
  echo ''
fi
echo '  ]'

echo '}'
} > "$REPORT"

# ═══════════════════════════════════════════════════════════════
#  PHASE 9 — Generate download script for missing images
# ═══════════════════════════════════════════════════════════════
if [ "$DO_DOWNLOAD" = true ] && [ -s "$MISSING_FILE" ]; then
  echo ""
  echo -e "${CYN}Generating download script: scripts/download-missing.sh${RST}"

  {
    echo '#!/usr/bin/env bash'
    echo '# Auto-generated by audit_images.sh v'"$AUDIT_VERSION"' on '"$(date +%Y-%m-%d)"
    echo '# Downloads all missing images identified by the audit.'
    echo '#'
    echo '# Usage:  bash scripts/download-missing.sh'
    echo ''
    echo 'set -eo pipefail'
    echo 'ROOT="$(cd "$(dirname "$0")/.." && pwd)"'
    echo 'UA="YawpMS-ImageBot/1.0 (educational textbook project)"'
    echo ''
    echo 'download() {'
    echo '  local dest="$1" url="$2"'
    echo '  local dir; dir=$(dirname "$dest")'
    echo '  mkdir -p "$ROOT/$dir"'
    echo '  echo -n "  Downloading $dest ... "'
    echo '  for attempt in 1 2 3; do'
    echo '    if curl -sL --fail --max-time 60 -A "$UA" "$url" -o "$ROOT/$dest" 2>/dev/null; then'
    echo '      local size; size=$(stat -c%s "$ROOT/$dest" 2>/dev/null || echo 0)'
    echo '      if [ "$size" -gt 1000 ]; then'
    echo '        echo "OK ($(( size / 1024 ))KB)"'
    echo '        return 0'
    echo '      fi'
    echo '    fi'
    echo '    sleep $((attempt * 2))'
    echo '  done'
    echo '  echo "FAILED"'
    echo '  return 1'
    echo '}'
    echo ''
    echo "echo \"Downloading missing images...\""
    echo "echo \"\""

    download_count=0
    while IFS='|' read -r type path sources url diffext similar mapsurl scriptname wikiurl; do
      effective_url="${url:-${mapsurl:-${wikiurl:-}}}"
      if [ -n "$effective_url" ]; then
        echo "download \"$path\" \"$effective_url\""
        download_count=$((download_count + 1))
      else
        echo "# NO URL: $path (referenced by $sources)"
      fi
    done < "$MISSING_FILE"

    echo ''
    echo "echo \"\""
    echo "echo \"Done. $download_count images attempted.\""
  } > "$DOWNLOAD_SCRIPT"

  chmod +x "$DOWNLOAD_SCRIPT"
  echo -e "  Generated with $download_count download commands"
  echo -e "  Run: ${BLD}bash scripts/download-missing.sh${RST}"
fi

# ═══════════════════════════════════════════════════════════════
#  PHASE 10 — Auto-fix name mismatches
# ═══════════════════════════════════════════════════════════════
if [ "$DO_FIXNAMES" = true ] && [ -s "$MISMATCH_FILE" ]; then
  echo ""
  echo -e "${CYN}Fixing name mismatches...${RST}"
  fixed=0
  while IFS='|' read -r missing candidate; do
    src="$ROOT/$candidate"
    dest="$ROOT/$missing"
    if [ -f "$src" ]; then
      mkdir -p "$(dirname "$dest")"
      cp "$src" "$dest"
      echo -e "  ${GRN}✓${RST} Copied $candidate → $missing"
      fixed=$((fixed + 1))
    else
      echo -e "  ${RED}✗${RST} Source not found: $candidate"
    fi
  done < "$MISMATCH_FILE"
  echo -e "  Fixed $fixed of $MISMATCH_COUNT mismatches"
fi

# ═══════════════════════════════════════════════════════════════
#  PHASE 11 — Clean up orphaned files
# ═══════════════════════════════════════════════════════════════
if [ "$DO_CLEAN" = true ] && [ -s "$ORPHAN_FILE" ]; then
  echo ""
  echo -e "${CYN}Removing orphaned files...${RST}"
  removed=0
  while IFS='|' read -r path size; do
    full="$ROOT/$path"
    if [ -f "$full" ]; then
      rm "$full"
      echo -e "  ${GRN}✓${RST} Removed $path ($size)"
      removed=$((removed + 1))
    fi
  done < "$ORPHAN_FILE"
  echo -e "  Removed $removed of $ORPHANS orphaned files"
fi

# ═══════════════════════════════════════════════════════════════
#  RECOMMENDATIONS
# ═══════════════════════════════════════════════════════════════
echo ""
echo -e "${BLD}============================================${RST}"
echo -e "${BLD}  RECOMMENDATIONS${RST}"
echo -e "${BLD}============================================${RST}"
echo ""

rec=1

if [ "$MISSING" -gt 0 ]; then
  with_url=$(awk -F'|' '$4 != "" || $7 != "" || $9 != ""' "$MISSING_FILE" | wc -l)
  without_url=$((MISSING - with_url))

  echo -e "  ${GRN}${rec}.${RST} Run download scripts to fetch $with_url images that have URLs:"
  echo -e "     ${CYN}bash scripts/download_all_images.sh${RST}"
  echo -e "     ${CYN}bash scripts/download_all_maps.sh${RST}"
  echo -e "     ${CYN}bash scripts/download_primary_source_images.sh${RST}"
  if [ "$DO_DOWNLOAD" = true ]; then
    echo -e "     ${CYN}bash scripts/download-missing.sh${RST}  (auto-generated)"
  else
    echo -e "     or run: ${CYN}bash scripts/audit_images.sh --download${RST} to generate a single download script"
  fi
  echo ""
  rec=$((rec + 1))
fi

if [ "$MISMATCH_COUNT" -gt 0 ]; then
  if [ "$DO_FIXNAMES" = true ]; then
    echo -e "  ${GRN}${rec}.${RST} Name mismatches were auto-fixed above."
  else
    echo -e "  ${GRN}${rec}.${RST} Fix $MISMATCH_COUNT name mismatches:"
    echo -e "     ${CYN}bash scripts/audit_images.sh --fix-names${RST}"
  fi
  echo ""
  rec=$((rec + 1))
fi

if [ "$MISSING" -gt 0 ]; then
  without_url=$(awk -F'|' '$4 == "" && $7 == "" && $9 == ""' "$MISSING_FILE" | wc -l)
  if [ "$without_url" -gt 0 ]; then
    echo -e "  ${GRN}${rec}.${RST} $without_url images have NO download URL. Find sources and"
    echo -e "     add to the download scripts, or source them manually."
    echo ""
    rec=$((rec + 1))
  fi
fi

if [ "$ORPHANS" -gt 0 ]; then
  if [ "$DO_CLEAN" = true ]; then
    echo -e "  ${GRN}${rec}.${RST} Orphaned files were cleaned up above."
  else
    echo -e "  ${GRN}${rec}.${RST} Review $ORPHANS orphaned files — old versions or unused assets."
    echo -e "     ${CYN}bash scripts/audit_images.sh --clean${RST}  to remove them"
  fi
  echo ""
fi

echo -e "${BLD}Full JSON report:${RST} $REPORT"
echo ""
