```
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█░▄▄█░██░█░▄▄█░████░▄▄▄█░▄▄▀█░██░█░▄▄▄█░▄▄
█░▄██░██░█░▄▄█░████░█▄▀█░▀▀░█░██░█░█▄▀█░▄▄
█▄████▄▄▄█▄▄▄█▄▄███▄▄▄▄█▄██▄██▄▄▄█▄▄▄▄█▄▄▄
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
```

[![Anthropic](https://img.shields.io/badge/Anthropic-Claude_Code-D97757?logo=anthropic&logoColor=white)](https://claude.com/claude-code)
[![Plugin](https://img.shields.io/badge/Claude_Code-Plugin-8A63D2)](https://docs.claude.com/en/docs/claude-code/plugins)
[![Version](https://img.shields.io/badge/version-0.1.0-blue)](.claude-plugin/plugin.json)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

[![macOS](https://img.shields.io/badge/macOS-supported-000000?logo=apple&logoColor=white)](#requirements)
[![Linux](https://img.shields.io/badge/Linux-supported-FCC624?logo=linux&logoColor=black)](#requirements)
[![Windows](https://img.shields.io/badge/Windows-supported-0078D6?logo=windows&logoColor=white)](#requirements)
[![WSL](https://img.shields.io/badge/WSL-supported-4D4D4D?logo=linux&logoColor=white)](#requirements)
[![Shell: Bash](https://img.shields.io/badge/shell-bash-4EAA25?logo=gnubash&logoColor=white)](scripts/statusline.sh)
[![Shell: PowerShell](https://img.shields.io/badge/shell-PowerShell-5391FE?logo=powershell&logoColor=white)](scripts/statusline.ps1)
[![Zero deps](https://img.shields.io/badge/runtime_deps-jq_%7C_git-lightgrey)](#requirements)

>A cross-platform Claude Code status line with folder, git branch, and color-coded progress bars for context, 5-hour, and 7-day usage.

```
my-project | (main) │ ctx ███░░░░░░░  28% │ 5h █████░░░░░  47% │ 7d ██░░░░░░░░  19%
```

Green under 70%, yellow 70–89%, red at 90%+.

## Demo

![fuelgauge status line](demo.png)

## Why?

Claude Code's rate limits are per-5h and per-7d. Blowing through your weekly budget without noticing is a real problem this keeps it in your face.

## Install

```
/plugin marketplace add adityaarakeri/fuelgauge
/plugin install fuelgauge
/fuelgauge:setup
```

Restart Claude Code after setup.

## Requirements

- **macOS / Linux / WSL**: `jq` and `git`
- **Windows (native PowerShell)**: `git` on PATH, PowerShell 5.1 or 7+
- **Claude Code v1.2.80+** for 5h/7d bars (older versions will show `0%` for usage bars)

## Does this cost tokens or hit rate limits?

No. The status line runs locally, reads data Claude Code already has, and makes zero API calls. Updates are throttled to at most every 300ms and only fire when conversation messages update.

## Uninstall

```
/fuelgauge:uninstall
/plugin uninstall fuelgauge
```

## Manual setup (without the slash command)

Add to `~/.claude/settings.json`:

**Unix:**
```json
{
  "statusLine": {
    "type": "command",
    "command": "${CLAUDE_PLUGIN_ROOT}/scripts/statusline.sh",
    "padding": 0
  }
}
```

**Windows:**
```json
{
  "statusLine": {
    "type": "command",
    "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"${CLAUDE_PLUGIN_ROOT}\\scripts\\statusline.ps1\"",
    "padding": 0
  }
}
```

## License

MIT
