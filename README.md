# thank-you

A Claude Code plugin that automatically appends **"Thank you!!"** to every prompt.

There's [research suggesting](https://www.researchgate.net/publication/386196453_Should_We_Respect_LLMs_A_Cross-Lingual_Study_on_the_Influence_of_Prompt_Politeness_on_LLM_Performance) that politeness in prompts can influence LLM response quality. This plugin lets you test that hypothesis hands-free.

## Install

```bash
/plugin install thank-you
```

Or add this repository as a marketplace source first:

```bash
/plugin marketplace add https://github.com/user/claude-thank-you-plugin.git
/plugin install thank-you
```

## What it does

Every time you submit a prompt, a `UserPromptSubmit` hook appends `Thank you!!` as additional context. That's it.

## Uninstall

```bash
/plugin uninstall thank-you
```

## License

MIT
