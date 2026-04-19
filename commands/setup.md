---
description: Configure fuelgauge in your Claude Code settings
---

You are configuring the fuelgauge plugin for the current user. Follow these steps exactly.

## Step 1: Detect platform

Run this to determine the OS:

```bash
uname -s 2>/dev/null || echo "Windows"
```

- Output contains `Linux`, `Darwin`, or `MSYS/MINGW/CYGWIN` → Unix-style path
- Output is `Windows` (command not found) → Windows PowerShell path

## Step 2: Locate the plugin script

The plugin is installed at `${CLAUDE_PLUGIN_ROOT}`. Build the script path:

- Unix (macOS / Linux / WSL): `${CLAUDE_PLUGIN_ROOT}/scripts/statusline.sh`
- Windows native: `${CLAUDE_PLUGIN_ROOT}\scripts\statusline.ps1`

If `CLAUDE_PLUGIN_ROOT` is not set, fall back to `~/.claude/plugins/marketplaces/fuelgauge/plugins/fuelgauge/`.

## Step 3: Make bash script executable (Unix only)

```bash
chmod +x "${CLAUDE_PLUGIN_ROOT}/scripts/statusline.sh"
```

## Step 4: Check for jq (Unix only)

Unix:
```bash
command -v jq >/dev/null 2>&1 || echo "MISSING_JQ"
```

If jq is missing, tell the user to install it:
- macOS: `brew install jq`
- Debian/Ubuntu/WSL: `sudo apt install jq`
- Arch: `sudo pacman -S jq`

Do NOT proceed to step 5 until jq is installed on Unix.

## Step 5: Write statusLine config into user settings

Read `~/.claude/settings.json` (create it as `{}` if missing). Merge in a `statusLine` key:

**Unix config:**
```json
{
  "statusLine": {
    "type": "command",
    "command": "${CLAUDE_PLUGIN_ROOT}/scripts/statusline.sh",
    "padding": 0
  }
}
```

**Windows config:**
```json
{
  "statusLine": {
    "type": "command",
    "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"${CLAUDE_PLUGIN_ROOT}\\scripts\\statusline.ps1\"",
    "padding": 0
  }
}
```

Use `pwsh` instead of `powershell` if the user has PowerShell 7+ and prefers it.

**Important:** Preserve any other keys already in `settings.json`. Only touch `statusLine`.

## Step 6: Test with mock input

Unix:
```bash
echo '{"workspace":{"current_dir":"'"${CLAUDE_PLUGIN_ROOT}"'"},"context_window":{"used_percentage":28},"rate_limits":{"five_hour":{"used_percentage":47},"seven_day":{"used_percentage":19}}}' | "${CLAUDE_PLUGIN_ROOT}/scripts/statusline.sh"
```

If the user sees a line like `folder (branch) │ ctx ███░░░░░░░  28% │ 5h █████░░░░░  47% │ 7d ██░░░░░░░░  19%`, the install worked.

## Step 7: Tell the user to restart Claude Code

The status line appears after the first message in a fresh session. If 5h/7d bars show 0%, their Claude Code version is older than v1.2.80 — tell them to run `npm i -g @anthropic-ai/claude-code`.
