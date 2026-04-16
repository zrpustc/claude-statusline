# Claude Code 状态栏

[English](README.md) | [中文](README_CN.md)

---

一个美观、功能丰富的 [Claude Code](https://claude.ai/code) 状态栏，使用 Catppuccin Mocha 主题。

![statusline preview](https://img.shields.io/badge/主题-Catppuccin%20Mocha-f5c2e7?style=flat-square)

## 功能特性

- **Catppuccin Mocha** 配色方案
- **多行布局**，全面展示信息
- **Git 集成**：显示分支名和状态标识（`+` 已暂存、`!` 已修改、`?` 未跟踪、`⇡⇣` 领先/落后）
- **上下文窗口** 进度条，根据使用率变色（绿色 < 50%，黄色 50-79%，红色 ≥ 80%）
- **费用追踪**，通过 [ccusage](https://github.com/ryoppippi/ccusage)（可选）：
  - 项目费用（今日）
  - 今日总费用
  - 本周费用
  - 本月费用
- **订阅模式** 支持显示速率限制（5小时/7天剩余）
- **Worktree 指示器**，用于 `--worktree` 会话
- **工具活动** 追踪（Read、Edit、Grep 等调用次数）
- **Agent 状态** 显示（运行中的 agent 及描述）
- **Todo 进度** 显示（已完成/总数）

## 预览

```
[Opus 4.5] ~/project │  main ?
Context ████░░░░░░ 45% │ $20.7/$26.2 W$181 M$181
✓ Edit: auth.ts | ✓ Read ×3 | ✓ Grep ×2
◐ explore: Finding auth code
▸ Fix authentication bug (2/5)
```

> **注意**：图标如 `󰀵`、`󰈙`、`` 需要安装 [Nerd Font](https://www.nerdfonts.com/) 才能正确显示。

**第一行**：`[模型名]` 系统图标 + 目录 │ Git 图标 + 分支 + 状态

**第二行**：上下文进度条 │ 费用信息（订阅用户显示速率限制）

**第三行**：工具活动（✓ 已完成）

**第四行**：Agent 状态（◐ 运行中）

**第五行**：Todo 进度（▸ 任务）

## 环境要求

- [Claude Code](https://claude.ai/code) CLI
- [jq](https://jqlang.github.io/jq/) 用于解析 JSON
- [Nerd Font](https://www.nerdfonts.com/) 用于显示图标（推荐：JetBrainsMono Nerd Font）
- [ccusage](https://github.com/ryoppippi/ccusage) 用于费用追踪（可选）

## 安装方法

### 快速安装

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

### 手动安装

1. 下载 `statusline.sh` 到 `~/.claude/`
2. 添加执行权限：`chmod +x ~/.claude/statusline.sh`
3. 将上述配置添加到 `~/.claude/settings.json`

## 配置说明

### 费用追踪（API 模式）

安装 [ccusage](https://github.com/ryoppippi/ccusage) 以获取真实费用数据：

```bash
npm install -g ccusage
```

状态栏会自动检测并显示：
- **项目费用**（绿色）- 当前项目今日费用
- **今日费用**（桃色）- 今日总费用
- **本周费用**（蓝宝石色）- 本周总费用
- **本月费用**（薰衣草色）- 本月总费用

### 订阅模式

对于 Claude.ai 订阅用户（Pro/Max），状态栏自动显示：
- **5h 剩余** - 5小时速率限制剩余百分比 + 重置时间
- **7d 剩余** - 7天速率限制剩余百分比 + 重置时间

## 配色方案

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
| 工具活动 | 蓝宝石色 | `#74c7ec` |
| Agent 状态 | 黄色 | `#f9e2af` |
| Todo 进度 | 绿色 | `#a6e3a1` |
| 分隔符 | 副文本色 | `#a6adc8` |

## Nerd Font 图标

本状态栏使用 [Nerd Font](https://www.nerdfonts.com/) 图标。请安装 Nerd Font（推荐 JetBrainsMono Nerd Font）并在终端中配置使用。

使用的图标：macOS 图标、文件夹图标（文档、下载、音乐、图片、开发者）、Git 分支图标。

## 自定义

编辑 `~/.claude/statusline.sh` 进行自定义：

- **颜色**：修改顶部的颜色变量
- **图标**：修改 `os_icon` 和 `git_icon` 变量
- **目录替换**：添加更多文件夹图标映射
- **缓存时间**：调整费用数据的缓存时长

## 常见问题

**图标不显示？**
- 安装 [Nerd Font](https://www.nerdfonts.com/) 并在终端中配置使用

**费用不显示？**
- 安装 `ccusage`：`npm install -g ccusage`
- 检查 `ccusage daily --json` 是否在终端中正常工作

**Git 分支显示 "(no branch)"？**
- 这发生在没有任何提交的新仓库中

**工具/Agent/Todo 不显示？**
- 这些功能需要通过 stdin JSON 中的 `transcript_path` 解析会话记录
- 只有在有活动数据时才会显示

## 致谢

- [Catppuccin](https://github.com/catppuccin/catppuccin) - 配色方案
- [ccusage](https://github.com/ryoppippi/ccusage) - 费用追踪
- [claude-hud](https://github.com/jarrodwatts/claude-hud) - Transcript 解析灵感来源
- [Starship](https://starship.rs/) - 提示符设计灵感

## 许可证

MIT License
