# Claude Code Statusline

[English](README.md) | [中文](README_CN.md)

---

A beautiful, feature-rich statusline for [Claude Code](https://claude.ai/code) with Catppuccin Mocha theme.

![statusline preview](https://img.shields.io/badge/theme-Catppuccin%20Mocha-f5c2e7?style=flat-square)

## Features

- **Catppuccin Mocha** color palette
- **Multi-line layout** for comprehensive information
- **Git integration** with branch name and status indicators (`+` staged, `!` modified, `?` untracked, `⇡⇣` ahead/behind)
- **Context window** progress bar with color-coded usage (green < 50%, yellow 50-79%, red ≥ 80%)
- **Cost tracking** via [ccusage](https://github.com/ryoppippi/ccusage) (optional):
  - Project cost (today)
  - Daily total
  - Weekly total
  - Monthly total
- **Subscription mode** support with rate limit display (5h/7d remaining)
- **Worktree** indicator for `--worktree` sessions
- **Tools activity** tracking (Read, Edit, Grep, etc. counts)
- **Agent status** display (running agents with description)
- **Todo progress** display (completed/total)

## Preview

```
[Opus 4.5] ~/project │  main ?
Context ████░░░░░░ 45% │ $20.7/$26.2 W$181 M$181
✓ Edit: auth.ts | ✓ Read ×3 | ✓ Grep ×2
◐ explore: Finding auth code
▸ Fix authentication bug (2/5)
```

> **Note**: Icons like `󰀵`, `󰈙`, `` require [Nerd Font](https://www.nerdfonts.com/) to display correctly.

**Line 1:** `[Model]` OS icon + Directory │ Git icon + branch + status

**Line 2:** Context progress bar │ Cost info (or rate limits for subscribers)

**Line 3:** Tools activity (✓ completed)

**Line 4:** Agent status (◐ running)

**Line 5:** Todo progress (▸ task)

## Requirements

- [Claude Code](https://claude.ai/code) CLI
- [jq](https://jqlang.github.io/jq/) for JSON parsing
- [Nerd Font](https://www.nerdfonts.com/) for icons (recommended: JetBrainsMono Nerd Font)
- [ccusage](https://github.com/ryoppippi/ccusage) for cost tracking (optional)

## Installation

### Quick Install

```bash
# Download the script
curl -o ~/.claude/statusline.sh https://raw.githubusercontent.com/zrpustc/claude-statusline/main/statusline.sh

# Make it executable
chmod +x ~/.claude/statusline.sh
```

Then add to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline.sh"
  }
}
```

### Manual Install

1. Download `statusline.sh` to `~/.claude/`
2. Make it executable: `chmod +x ~/.claude/statusline.sh`
3. Add the configuration above to `~/.claude/settings.json`

## Configuration

### Cost Tracking (API Mode)

Install [ccusage](https://github.com/ryoppippi/ccusage) for real cost tracking:

```bash
npm install -g ccusage
```

The statusline will automatically detect and display:
- **Project cost** (green) - Current project's cost today
- **Daily cost** (peach) - Total cost today
- **Weekly cost** (sapphire) - This week's total
- **Monthly cost** (lavender) - This month's total

### Subscription Mode

For Claude.ai subscribers (Pro/Max), the statusline automatically shows:
- **5h remaining** - 5-hour rate limit remaining percentage + reset time
- **7d remaining** - 7-day rate limit remaining percentage + reset time

## Color Palette

Uses [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) colors:

| Element | Color | Hex |
|---------|-------|-----|
| Model bracket | Text | `#cdd6f4` |
| OS icon | Red | `#f38ba8` |
| Directory | Peach | `#fab387` |
| Git info | Yellow | `#f9e2af` |
| Context (low) | Green | `#a6e3a1` |
| Context (mid) | Yellow | `#f9e2af` |
| Context (high) | Red | `#f38ba8` |
| Project cost | Green | `#a6e3a1` |
| Daily cost | Peach | `#fab387` |
| Weekly cost | Sapphire | `#74c7ec` |
| Monthly cost | Lavender | `#b4befe` |
| Tools activity | Sapphire | `#74c7ec` |
| Agent status | Yellow | `#f9e2af` |
| Todo progress | Green | `#a6e3a1` |
| Separator | Subtext | `#a6adc8` |

## Nerd Font Icons

This statusline uses [Nerd Font](https://www.nerdfonts.com/) icons. Install a Nerd Font (e.g., JetBrainsMono Nerd Font) and configure your terminal to use it.

Icons used: macOS logo, folder icons (Documents, Downloads, Music, Pictures, Developer), Git branch icon.

## Customization

Edit `~/.claude/statusline.sh` to customize:

- **Colors**: Modify the color variables at the top
- **Icons**: Change `os_icon` and `git_icon` variables
- **Directory substitutions**: Add more folder icon mappings
- **Cache TTL**: Adjust cache durations for cost data

## Troubleshooting

**Icons not displaying?**
- Install a [Nerd Font](https://www.nerdfonts.com/) and configure your terminal to use it

**Cost not showing?**
- Install `ccusage`: `npm install -g ccusage`
- Check if `ccusage daily --json` works in your terminal

**Git branch shows "(no branch)"?**
- This happens in repos without any commits yet

**Tools/Agent/Todo not showing?**
- These require transcript parsing via `transcript_path` in stdin JSON
- They only appear when there's activity to display

## Credits

- [Catppuccin](https://github.com/catppuccin/catppuccin) - Color palette
- [ccusage](https://github.com/ryoppippi/ccusage) - Cost tracking
- [claude-hud](https://github.com/jarrodwatts/claude-hud) - Transcript parsing inspiration
- [Starship](https://starship.rs/) - Prompt design inspiration

## License

MIT License
