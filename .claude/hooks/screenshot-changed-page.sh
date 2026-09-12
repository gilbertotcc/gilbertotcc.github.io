#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

cd "$CLAUDE_PROJECT_DIR" || exit 0

# A directly-edited page file only needs that one page re-checked. Any other
# edit under site/src/ (components, data, layouts, etc.) can still change how
# a page renders — e.g. editing site/src/data/publications.yml changes the
# length of the Thought Leadership page — so it triggers a full sweep of
# every page instead, since we don't track which page(s) consume which file.
case "$FILE_PATH" in
  site/src/pages/*.astro|site/src/pages/*.md) MODE="single" ;;
  site/src/*) MODE="sweep" ;;
  *) exit 0 ;;
esac

file_to_route() {
  local file="$1"
  local base="${file#site/src/pages/}"
  base="${base%.astro}"
  base="${base%.md}"
  if [[ "$base" == *"["* ]]; then
    return
  fi
  if [[ "$base" == "index" ]]; then
    echo "/"
  elif [[ "$base" == */index ]]; then
    echo "/${base%/index}"
  else
    echo "/$base"
  fi
}

ROUTES=()
if [ "$MODE" = "single" ]; then
  ROUTE=$(file_to_route "$FILE_PATH")
  if [ -z "$ROUTE" ]; then
    jq -n --arg f "$FILE_PATH" \
      '{hookSpecificOutput: {additionalContext: ("astro-visual-check: skipped " + $f + " — dynamic route, no concrete URL to screenshot.")}}'
    exit 0
  fi
  ROUTES=("$ROUTE")
else
  while IFS= read -r -d '' page_file; do
    route=$(file_to_route "$page_file")
    [ -n "$route" ] && ROUTES+=("$route")
  done < <(find site/src/pages -type f \( -name '*.astro' -o -name '*.md' \) -print0)
fi

CHECK_OUTPUT=$(npm run site:check 2>&1)
CHECK_STATUS=$?

if [ $CHECK_STATUS -ne 0 ]; then
  jq -n --arg f "$FILE_PATH" --arg out "$CHECK_OUTPUT" \
    '{hookSpecificOutput: {additionalContext: ("astro-visual-check: " + $f + " — `astro check` FAILED, skipping screenshot:\n" + $out)}}'
  exit 0
fi

# Ensure the Astro dev server is reachable before screenshotting anything;
# reuse one already running, otherwise start it in the background and poll
# until it responds (bounded wait, so a stuck server can't hang the hook).
is_port_open() {
  node -e "fetch('http://localhost:4321/').then(()=>process.exit(0)).catch(()=>process.exit(1))" 2>/dev/null
}

if ! is_port_open; then
  nohup npm run site:dev >/dev/null 2>&1 &
  for _ in $(seq 1 20); do
    is_port_open && break
    sleep 1
  done
fi

if ! is_port_open; then
  jq -n --arg f "$FILE_PATH" \
    '{hookSpecificOutput: {additionalContext: ("astro-visual-check: " + $f + " — astro check passed, but the dev server never came up on :4321, skipping screenshot.")}}'
  exit 0
fi

SUMMARY=""
for ROUTE in "${ROUTES[@]}"; do
  SLUG=$(echo "${ROUTE#/}" | tr '/' '-')
  [ -z "$SLUG" ] && SLUG="index"
  OUT_PREFIX="tmp/${SLUG}"
  mkdir -p "$(dirname "$OUT_PREFIX")"
  SCREENSHOT_OUTPUT=$(node scripts/screenshot_page.mts "http://localhost:4321${ROUTE}" "$OUT_PREFIX" 2>&1)
  SUMMARY="${SUMMARY}
${ROUTE}: ${SCREENSHOT_OUTPUT}"
done

jq -n --arg f "$FILE_PATH" --arg mode "$MODE" --arg out "$SUMMARY" \
  '{hookSpecificOutput: {additionalContext: ("astro-visual-check: " + $f + " (" + $mode + " mode) — astro check passed, screenshots captured:" + $out + "\nRead the screenshot PNGs and visually review them before considering this edit done.")}}'
exit 0
