#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

PROTECTED='(terraform/|\.github/workflows/|curriculum-vitae/)'
MUTATING='(^|[;&|[:space:]])(rm|mv|cp|sed[[:space:]]+-i[[:space:]]*[a-zA-Z]*|tee|git[[:space:]]+rm|chmod|truncate)[[:space:]]|>>?[[:space:]]*[^&]*'"$PROTECTED"

if echo "$COMMAND" | grep -Eq "$PROTECTED" && echo "$COMMAND" | grep -Eq "$MUTATING"; then
  echo "Blocked: this command appears to modify a read-only path (terraform/, .github/workflows/, or curriculum-vitae/). See CLAUDE.md hard constraints." >&2
  exit 2
fi

exit 0
