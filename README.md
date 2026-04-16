# Claude Code Statusline

[English](#english) | [中文](#中文)

---

<a name="english"></a>
## English

A beautiful, feature-rich statusline for [Claude Code](https://claude.ai/code) with Catppuccin Mocha theme.

![statusline preview](https://img.shields.io/badge/theme-Catppuccin%20Mocha-f5c2e7?style=flat-square)

### Features

- **Catppuccin Mocha** color palette
- **Two-line layout** for better readability
- **Git integration** with branch name and status indicators (`+` staged, `!` modified, `?` untracked, `⇡⇣` ahead/behind)
- **Context window** progress bar with color-coded usage (green < 50%, yellow 50-79%, red ≥ 80%)
- **Cost tracking** via [ccusage](https://github.com/ryoppippi/ccusage) (optional):
  - Project cost (today)
  - Daily total
  - Weekly total
  - Monthly total
- **Subscription mode** support with rate limit display (5h/7d remaining)
- **Worktree** indicator for `--worktree` sessions

### Preview

```
[Opus 4.5]  ~/Documents/project │  main ?
Context ████░░░░░░ 45% │ $20.7/$26.2 W$181 M$181
```

> **Note**: The icons above (``, ``, ``) are [Nerd Font](https://www.nerdfonts.com/) glyphs. They will display correctly in terminals with Nerd Fonts installed.

**Line 1:** `[Model]` OS icon + Directory │ Git icon + branch + status

**Line 2:** Context progress bar │ Cost info (or rate limits for subscribers)

### Requirements

- [Claude Code](https://claude.ai/code) CLI
- [jq](https://jqlang.github.io/jq/) for JSON parsing
- [Nerd Font](https://www.nerdfonts.com/) for icons (recommended: JetBrainsMono Nerd Font)
- [ccusage](https://github.com/ryoppippi/ccusage) for cost tracking (optional)

### Installation

#### Quick Install

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

#### Manual Install

1. Download `statusline.sh` to `~/.claude/`
2. Make it executable: `chmod +x ~/.claude/statusline.sh`
3. Add the configuration above to `~/.claude/settings.json`

### Configuration

#### Cost Tracking (API Mode)

Install [ccusage](https://github.com/ryoppippi/ccusage) for real cost tracking:

```bash
npm install -g ccusage
```

The statusline will automatically detect and display:
- **Project cost** (green) - Current project's cost today
- **Daily cost** (peach) - Total cost today
- **Weekly cost** (sapphire) - This week's total
- **Monthly cost** (lavender) - This month's total

#### Subscription Mode

For Claude.ai subscribers (Pro/Max), the statusline automatically shows:
- **5h remaining** - 5-hour rate limit remaining percentage + reset time
- **7d remaining** - 7-day rate limit remaining percentage + reset time

### Color Palette

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
| Separator | Subtext | `#a6adc8` |

### Nerd Font Icons Used

| Icon | Codepoint | Description |
|------|-----------|-------------|
| `` | `U+F0635` | macOS logo |
| `` | `U+F0219` | Documents folder |
| `` | `U+F019` | Downloads folder |
| `` | `U+F075A` | Music folder |
| `` | `U+F03E` | Pictures folder |
| `` | `U+F0CBB` | Developer folder |
| `` | `U+E725` | Git branch |

### Customization

Edit `~/.claude/statusline.sh` to customize:

- **Colors**: Modify the color variables at the top
- **Icons**: Change `os_icon` and `git_icon` variables
- **Directory substitutions**: Add more folder icon mappings
- **Cache TTL**: Adjust cache durations for cost data

### Troubleshooting

**Icons not displaying?**
- Install a [Nerd Font](https://www.nerdfonts.com/) and configure your terminal to use it

**Cost not showing?**
- Install `ccusage`: `npm install -g ccusage`
- Check if `ccusage daily --json` works in your terminal

**Git branch shows "(no branch)"?**
- This happens in repos without any commits yet

---

<a name="中文"></a>
## 中文

一个美观、功能丰富的 [Claude Code](https://claude.ai/code) 状态栏，使用 Catppuccin Mocha 主题。

![statusline preview](https://img.shields.io/badge/主题-Catppuccin%20Mocha-f5c2e7?style=flat-square)

### 功能特性

- **Catppuccin Mocha** 配色方案
- **双行布局**，更易阅读
- **Git 集成**：显示分支名和状态标识（`+` 已暂存、`!` 已修改、`?` 未跟踪、`⇡⇣` 领先/落后）
- **上下文窗口** 进度条，根据使用率变色（绿色 < 50%，黄色 50-79%，红色 ≥ 80%）
- **费用追踪**，通过 [ccusage](https://github.com/ryoppippi/ccusage)（可选）：
  - 项目费用（今日）
  - 今日总费用
  - 本周费用
  - 本月费用
- **订阅模式** 支持显示速率限制（5小时/7天剩余）
- **Worktree 指示器**，用于 `--worktree` 会话

### 预览

```
[Opus 4.5]  ~/Documents/project │  main ?
Context ████░░░░░░ 45% │ $20.7/$26.2 W$181 M$181
```

> **注意**：上面的图标（``, ``, ``）是 [Nerd Font](https://www.nerdfonts.com/) 字形，需要安装 Nerd Font 才能正确显示。

**第一行**：`[模型名]` 系统图标 + 目录 │ Git 图标 + 分支 + 状态

**第二行**：上下文进度条 │ 费用信息（订阅用户显示速率限制）

### 环境要求

- [Claude Code](https://claude.ai/code) CLI
- [jq](https://jqlang.github.io/jq/) 用于解析 JSON
- [Nerd Font](https://www.nerdfonts.com/) 用于显示图标（推荐：JetBrainsMono Nerd Font）
- [ccusage](https://github.com/ryoppippi/ccusage) 用于费用追踪（可选）

### 安装方法

#### 快速安装

```bash
# 下载脚本
curl -o ~/.claude/statusline.sh https://raw.githubusercontent.com/zrpustc/claude-statusline/main/statusline.sh

# 添加执行权限
chmod +x ~/.claude/statusline.sh
```

然后在 `~/.claude/settings.json` 中添加：

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline.sh"
  }
}
```

#### 手动安装

1. 下载 `statusline.sh` 到 `~/.claude/`
2. 添加执行权限：`chmod +x ~/.claude/statusline.sh`
3. 将上述配置添加到 `~/.claude/settings.json`

### 配置说明

#### 费用追踪（API 模式）

安装 [ccusage](https://github.com/ryoppippi/ccusage) 以获取真实费用数据：

```bash
npm install -g ccusage
```

状态栏会自动检测并显示：
- **项目费用**（绿色）- 当前项目今日费用
- **今日费用**（桃色）- 今日总费用
- **本周费用**（蓝宝石色）- 本周总费用
- **本月费用**（薰衣草色）- 本月总费用

#### 订阅模式

对于 Claude.ai 订阅用户（Pro/Max），状态栏自动显示：
- **5h 剩余** - 5小时速率限制剩余百分比 + 重置时间
- **7d 剩余** - 7天速率限制剩余百分比 + 重置时间

### 配色方案

使用 [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) 配色：

| 元素 | 颜色 | 十六进制 |
|------|------|----------|
| 模型名括号 | 文本色 | `#cdd6f4` |
| 系统图标 | 红色 | `#f38ba8` |
| 目录 | 桃色 | `#fab387` |
| Git 信息 | 黄色 | `#f9e2af` |
| 上下文（低） | 绿色 | `#a6e3a1` |
| 上下文（中） | 黄色 | `#f9e2af` |
| 上下文（高） | 红色 | `#f38ba8` |
| 项目费用 | 绿色 | `#a6e3a1` |
| 今日费用 | 桃色 | `#fab387` |
| 本周费用 | 蓝宝石色 | `#74c7ec` |
| 本月费用 | 薰衣草色 | `#b4befe` |
| 分隔符 | 副文本色 | `#a6adc8` |

### 使用的 Nerd Font 图标

| 图标 | 码点 | 描述 |
|------|------|------|
| `` | `U+F0635` | macOS 图标 |
| `` | `U+F0219` | 文档文件夹 |
| `` | `U+F019` | 下载文件夹 |
| `` | `U+F075A` | 音乐文件夹 |
| `` | `U+F03E` | 图片文件夹 |
| `` | `U+F0CBB` | 开发者文件夹 |
| `` | `U+E725` | Git 分支 |

### 自定义

编辑 `~/.claude/statusline.sh` 进行自定义：

- **颜色**：修改顶部的颜色变量
- **图标**：修改 `os_icon` 和 `git_icon` 变量
- **目录替换**：添加更多文件夹图标映射
- **缓存时间**：调整费用数据的缓存时长

### 常见问题

**图标不显示？**
- 安装 [Nerd Font](https://www.nerdfonts.com/) 并在终端中配置使用

**费用不显示？**
- 安装 `ccusage`：`npm install -g ccusage`
- 检查 `ccusage daily --json` 是否在终端中正常工作

**Git 分支显示 "(no branch)"？**
- 这发生在没有任何提交的新仓库中

---

## Credits / 致谢

- [Catppuccin](https://github.com/catppuccin/catppuccin) for the color palette / 配色方案
- [ccusage](https://github.com/ryoppippi/ccusage) for cost tracking / 费用追踪
- Inspired by [Starship](https://starship.rs/) prompt / 灵感来源

## License / 许可证

MIT License
