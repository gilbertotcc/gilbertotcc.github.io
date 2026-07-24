#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -Eq '(^|[;&|[:space:]])tofu[[:space:]]+apply([[:space:]]|$)'; then
  echo "Blocked: 'tofu apply' is not allowed. See CLAUDE.md hard constraints." >&2
  exit 2
fi

exit 0
