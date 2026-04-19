---
description: Remove fuelguage from your Claude Code settings
---

Open `~/.claude/settings.json` and remove the `statusLine` key if its `command` value contains `fuelguage`. Leave all other settings untouched.

Tell the user the status line will disappear on next restart, and that the plugin itself can be removed with `/plugin uninstall fuelguage`.
