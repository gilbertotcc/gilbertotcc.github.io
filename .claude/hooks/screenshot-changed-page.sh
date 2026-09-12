#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

cd "$CLAUDE_PROJECT_DIR" || exit 0

# Only Astro/Markdown files under site/src/pages/ are visual pages.
# .ts files there are API endpoints (e.g. llms.txt.ts) with no visual output.
case "$FILE_PATH" in
  site/src/pages/*.astro|site/src/pages/*.md) ;;
  *) exit 0 ;;
esac

REL="${FILE_PATH#site/src/pages/}"
ROUTE_BASE="${REL%.astro}"
ROUTE_BASE="${ROUTE_BASE%.md}"

if [[ "$ROUTE_BASE" == *"["* ]]; then
  jq -n --arg f "$FILE_PATH" \
    '{hookSpecificOutput: {additionalContext: ("astro-visual-check: skipped " + $f + " — dynamic route, no concrete URL to screenshot.")}}'
  exit 0
fi

if [[ "$ROUTE_BASE" == "index" ]]; then
  ROUTE="/"
elif [[ "$ROUTE_BASE" == */index ]]; then
  ROUTE="/${ROUTE_BASE%/index}"
else
  ROUTE="/$ROUTE_BASE"
fi

CHECK_OUTPUT=$(npm run site:check 2>&1)
CHECK_STATUS=$?

if [ $CHECK_STATUS -ne 0 ]; then
  jq -n --arg f "$FILE_PATH" --arg out "$CHECK_OUTPUT" \
    '{hookSpecificOutput: {additionalContext: ("astro-visual-check: " + $f + " — `astro check` FAILED, skipping screenshot:\n" + $out)}}'
  exit 0
fi

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

SLUG=$(echo "$ROUTE_BASE" | tr '/' '-')
[ -z "$SLUG" ] && SLUG="index"
OUT_PREFIX="tmp/${SLUG}"
mkdir -p "$(dirname "$OUT_PREFIX")"

SCREENSHOT_OUTPUT=$(node scripts/screenshot_page.mts "http://localhost:4321${ROUTE}" "$OUT_PREFIX" 2>&1)

jq -n --arg f "$FILE_PATH" --arg route "$ROUTE" --arg out "$SCREENSHOT_OUTPUT" \
  '{hookSpecificOutput: {additionalContext: ("astro-visual-check: " + $f + " (route " + $route + ") — astro check passed, screenshots captured:\n" + $out + "\nRead the screenshot PNGs and visually review them before considering this edit done.")}}'
exit 0
