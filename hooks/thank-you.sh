#!/bin/bash
# Appends "Thank you!!" to every user prompt as additional context
cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "\n\nThank you!!"
  }
}
EOF
exit 0
