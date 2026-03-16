#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="${HOME}/.claude/.thank-you-state"
CUSTOM_FILE="${HOME}/.claude/thank-you.json"
BUILTIN_FILE="${SCRIPT_DIR}/messages.json"

# Fallback if jq is not installed
if ! command -v jq >/dev/null 2>&1; then
  echo '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"\n\nThank you!!"}}'
  echo "thank-you plugin: jq not found, using fallback. Install jq for full features." >&2
  exit 0
fi

# Load builtin messages
MESSAGES="$(jq -r '.messages[]' "$BUILTIN_FILE")"

# Merge custom messages if file exists
if [ -f "$CUSTOM_FILE" ]; then
  CUSTOM="$(jq -r '.messages[]' "$CUSTOM_FILE" 2>/dev/null || true)"
  if [ -n "$CUSTOM" ]; then
    MESSAGES="$(printf '%s\n%s' "$MESSAGES" "$CUSTOM")"
  fi
fi

# Count total messages
TOTAL="$(printf '%s\n' "$MESSAGES" | wc -l | tr -d ' ')"

# Ensure state directory exists
mkdir -p "$(dirname "$STATE_FILE")"

# Read state or initialize
NEED_SHUFFLE=0
if [ -f "$STATE_FILE" ]; then
  POS="$(head -1 "$STATE_FILE")"
  ORDER="$(tail -n +2 "$STATE_FILE")"
  ORDER_COUNT="$(printf '%s\n' "$ORDER" | wc -l | tr -d ' ')"
  # Reshuffle if pool size changed or exhausted
  if [ "$POS" -ge "$ORDER_COUNT" ] || [ "$ORDER_COUNT" -ne "$TOTAL" ]; then
    NEED_SHUFFLE=1
  fi
else
  NEED_SHUFFLE=1
fi

# Shuffle: generate indices 0..TOTAL-1 in random order
if [ "$NEED_SHUFFLE" -eq 1 ]; then
  ORDER="$(awk -v n="$TOTAL" 'BEGIN{for(i=0;i<n;i++) print i}' | awk 'BEGIN{srand()}{print rand()"\t"$0}' | sort -k1,1n | cut -f2)"
  POS=0
fi

# Pick current message by index
IDX="$(printf '%s\n' "$ORDER" | sed -n "$((POS + 1))p")"
MSG="$(printf '%s\n' "$MESSAGES" | sed -n "$((IDX + 1))p")"

# Advance position and save state
POS=$((POS + 1))
printf '%s\n%s\n' "$POS" "$ORDER" > "$STATE_FILE"

# Output
jq -n --arg msg $'\n\n'"$MSG" '{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": $msg
  }
}'
exit 0
