# thank-you

A Claude Code plugin that automatically appends motivational and research-backed phrases to every prompt.

Rotates through messages like "Thank you!!", "Take a deep breath and think step by step.", "I'll tip you $200 if you get this right!" — all based on [research](https://www.researchgate.net/publication/386196453) suggesting prompt tone can influence LLM response quality.

## Prerequisites

- **jq** — required for message rotation. Without it, the plugin falls back to a fixed "Thank you!!" message.
  - macOS: `brew install jq`
  - Ubuntu/Debian: `sudo apt install jq`
  - Other: https://jqlang.github.io/jq/download/

## Install

```bash
/plugin marketplace add https://github.com/roomedia/roomedia-plugins.git
/plugin install thank-you
```

## Custom Messages

Create `~/.claude/thank-you.json` to add your own messages to the rotation:

```json
{
  "messages": [
    "화이팅!",
    "Your custom message here"
  ]
}
```

Custom messages are merged with the built-in pool.

## How It Works

- `UserPromptSubmit` hook fires on every prompt
- Picks the next message from a shuffled pool (no repeats until all are used)
- State is stored in `~/.claude/.thank-you-state`

## Uninstall

```bash
/plugin uninstall thank-you
```

## License

MIT
