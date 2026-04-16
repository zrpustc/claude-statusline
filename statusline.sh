#!/usr/bin/env bash
# Claude Code status line
# Line 1: OS icon | directory | git branch+status | model
# Line 2: context bar | worktree | usage (API cost or subscription limits)

input=$(cat)

# --- Catppuccin Mocha palette (true-color) ---
RED='\033[38;2;243;139;168m'
PEACH='\033[38;2;250;179;135m'
YELLOW='\033[38;2;249;226;175m'
GREEN='\033[38;2;166;227;161m'
SAPPHIRE='\033[38;2;116;199;236m'
LAVENDER='\033[38;2;180;190;254m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT='\033[38;2;166;173;200m'
RESET='\033[0m'

# --- OS icon (macOS) ---
os_icon="󰀵"

# --- Git icon (nerd font U+E725) ---
git_icon=$'\xee\x9c\xa5'

# --- Directory (truncated to last 3 components, with substitutions) ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
if [ -n "$cwd" ]; then
  cwd="${cwd/#$HOME/\~}"
  cwd="${cwd//Documents/󰈙 }"
  cwd="${cwd//Downloads/ }"
  cwd="${cwd//Music/󰝚 }"
  cwd="${cwd//Pictures/ }"
  cwd="${cwd//Developer/󰲋 }"
  IFS='/' read -ra parts <<< "$cwd"
  num=${#parts[@]}
  if [ "$num" -gt 4 ]; then
    cwd="…/"
    for (( i=num-3; i<num; i++ )); do
      cwd="${cwd}${parts[$i]}"
      if [ "$i" -lt $((num-1)) ]; then cwd="${cwd}/"; fi
    done
  fi
fi

# --- Git branch and status (with  icon) ---
git_info=""
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // empty')
[ -z "$project_dir" ] && project_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')

if [ -n "$project_dir" ]; then
  if [ -d "$project_dir/.git" ] || [ -f "$project_dir/.git" ]; then
    # Use git branch --show-current which works better for new repos
    git_branch=$(git -C "$project_dir" --no-optional-locks branch --show-current 2>/dev/null)
    # Fallback to rev-parse if branch --show-current returns empty
    [ -z "$git_branch" ] && git_branch=$(git -C "$project_dir" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
    [ -z "$git_branch" ] && git_branch="(no branch)"

    if [ -n "$git_branch" ]; then
      status_flags=""
      staged=$(git -C "$project_dir" --no-optional-locks diff --cached --name-only 2>/dev/null | head -1)
      [ -n "$staged" ] && status_flags="${status_flags}+"
      if ! git -C "$project_dir" --no-optional-locks diff --quiet 2>/dev/null; then
        status_flags="${status_flags}!"
      fi
      untracked=$(git -C "$project_dir" --no-optional-locks ls-files --others --exclude-standard 2>/dev/null | head -1)
      [ -n "$untracked" ] && status_flags="${status_flags}?"
      ab=$(git -C "$project_dir" --no-optional-locks rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
      if [ -n "$ab" ]; then
        ahead=$(echo "$ab" | awk '{print $1}')
        behind=$(echo "$ab" | awk '{print $2}')
        [ "$ahead" -gt 0 ] 2>/dev/null && status_flags="${status_flags}⇡${ahead}"
        [ "$behind" -gt 0 ] 2>/dev/null && status_flags="${status_flags}⇣${behind}"
      fi
      git_info="${git_icon} ${git_branch}${status_flags:+ ${status_flags}}"
    fi
  fi
fi

# --- Model ---
model_display=$(echo "$input" | jq -r '.model.display_name // empty')

# --- Context usage with progress bar ---
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_info=""
if [ -n "$used" ] && [ "$used" != "null" ]; then
  used_int=$(printf '%.0f' "$used")
  if [ "$used_int" -ge 80 ]; then
    ctx_color="$RED"
  elif [ "$used_int" -ge 50 ]; then
    ctx_color="$YELLOW"
  else
    ctx_color="$GREEN"
  fi
  bar_len=10
  filled=$(( used_int * bar_len / 100 ))
  [ "$filled" -gt "$bar_len" ] && filled=$bar_len
  empty=$(( bar_len - filled ))
  bar=""
  for (( i=0; i<filled; i++ )); do bar="${bar}█"; done
  for (( i=0; i<empty; i++ )); do bar="${bar}░"; done
  ctx_info="${SUBTEXT}Context ${ctx_color}${bar} ${used_int}%%${RESET}"
fi

# --- Usage info: auto-detect subscription vs API mode ---
usage_info=""
has_rate_limits=$(echo "$input" | jq -r 'if .rate_limits and ((.rate_limits.five_hour // null) != null or (.rate_limits.seven_day // null) != null) then "yes" else "no" end')
now_epoch=$(date +%s)

if [ "$has_rate_limits" = "yes" ]; then
  # --- Subscription mode: show remaining percentage ---
  five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
  five_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
  week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
  week_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

  # 5h remaining and reset time
  if [ -n "$five_pct" ] && [ "$five_pct" != "null" ]; then
    five_int=$(printf '%.0f' "$five_pct")
    five_remain=$((100 - five_int))
    if [ "$five_remain" -le 20 ]; then rc="$RED"
    elif [ "$five_remain" -le 50 ]; then rc="$YELLOW"
    else rc="$GREEN"; fi

    reset_time=""
    if [ -n "$five_resets" ] && [ "$five_resets" != "null" ]; then
      reset_time="@$(date -r "$five_resets" +%H:%M 2>/dev/null)"
    fi
    usage_info="${rc}5h:${five_remain}%%${reset_time}${RESET}"
  fi

  # 7d remaining
  if [ -n "$week_pct" ] && [ "$week_pct" != "null" ]; then
    week_int=$(printf '%.0f' "$week_pct")
    week_remain=$((100 - week_int))
    if [ "$week_remain" -le 20 ]; then rc="$RED"
    elif [ "$week_remain" -le 50 ]; then rc="$YELLOW"
    else rc="$GREEN"; fi

    reset_tag=""
    if [ -n "$week_resets" ] && [ "$week_resets" != "null" ]; then
      remaining_sec=$(( week_resets - now_epoch ))
      if [ "$remaining_sec" -gt 86400 ]; then
        days_left=$(echo "scale=1; $remaining_sec / 86400" | bc 2>/dev/null)
        reset_tag="@${days_left}d"
      else
        reset_tag="@$(date -r "$week_resets" +%H:%M 2>/dev/null)"
      fi
    fi
    usage_info="${usage_info:+${usage_info} }${rc}7d:${week_remain}%%${reset_tag}${RESET}"
  fi
else
  # --- API mode: show cost info via ccusage ---
  cost_parts=""

  if command -v ccusage &>/dev/null; then
    today_date=$(date +%Y%m%d)

    # --- Daily cost - cached 60s ---
    daily_cache="/tmp/cl_status_daily.txt"
    if [ -f "$daily_cache" ]; then
      mtime=$(stat -f %m "$daily_cache" 2>/dev/null || echo 0)
      age=$(( now_epoch - mtime ))
    else
      age=9999
    fi
    if [ "$age" -lt 60 ]; then
      daily_raw=$(cat "$daily_cache")
    else
      daily_raw=$(ccusage daily --json --since "$today_date" -i 2>/dev/null)
      echo "$daily_raw" > "$daily_cache" 2>/dev/null
    fi

    if [ -n "$daily_raw" ] && echo "$daily_raw" | jq -e . &>/dev/null; then
      daily_total=$(echo "$daily_raw" | jq -r '.totals.totalCost // 0' 2>/dev/null)
      daily_total=${daily_total:-0}

      # Get project cost
      project_dir_raw=$(echo "$input" | jq -r '.workspace.project_dir // empty')
      if [ -n "$project_dir_raw" ]; then
        project_key=$(echo "$project_dir_raw" | sed 's|/|-|g; s|_|-|g')
        project_cost=$(echo "$daily_raw" | jq -r --arg p "$project_key" '.projects[$p][0].totalCost // 0' 2>/dev/null)
        project_cost=${project_cost:-0}
      else
        project_cost=0
      fi

      # Project (Green)
      if [ "$(echo "$project_cost > 0" | bc 2>/dev/null)" = "1" ]; then
        cost_parts="${GREEN}\$$(printf '%.1f' "$project_cost")${RESET}"
      fi

      # Daily (Peach)
      if [ "$(echo "$daily_total > 0" | bc 2>/dev/null)" = "1" ]; then
        cost_parts="${cost_parts:+${cost_parts}/}${PEACH}\$$(printf '%.1f' "$daily_total")${RESET}"
      fi
    fi

    # --- Weekly cost - cached 300s ---
    weekly_cache="/tmp/cl_status_weekly.txt"
    if [ -f "$weekly_cache" ]; then
      mtime=$(stat -f %m "$weekly_cache" 2>/dev/null || echo 0)
      age=$(( now_epoch - mtime ))
    else
      age=9999
    fi
    if [ "$age" -lt 300 ]; then
      weekly_raw=$(cat "$weekly_cache")
    else
      weekly_raw=$(ccusage weekly --json 2>/dev/null)
      echo "$weekly_raw" > "$weekly_cache" 2>/dev/null
    fi

    # Weekly (Sapphire)
    if [ -n "$weekly_raw" ] && echo "$weekly_raw" | jq -e . &>/dev/null; then
      weekly_cost=$(echo "$weekly_raw" | jq -r '.weekly[-1].totalCost // 0' 2>/dev/null)
      if [ "$(echo "$weekly_cost > 0" | bc 2>/dev/null)" = "1" ]; then
        cost_parts="${cost_parts:+${cost_parts} }${SAPPHIRE}W\$$(printf '%.0f' "$weekly_cost")${RESET}"
      fi
    fi

    # --- Monthly cost - cached 600s ---
    monthly_cache="/tmp/cl_status_monthly.txt"
    if [ -f "$monthly_cache" ]; then
      mtime=$(stat -f %m "$monthly_cache" 2>/dev/null || echo 0)
      age=$(( now_epoch - mtime ))
    else
      age=9999
    fi
    if [ "$age" -lt 600 ]; then
      monthly_raw=$(cat "$monthly_cache")
    else
      monthly_raw=$(ccusage monthly --json 2>/dev/null)
      echo "$monthly_raw" > "$monthly_cache" 2>/dev/null
    fi

    # Monthly (Lavender)
    if [ -n "$monthly_raw" ] && echo "$monthly_raw" | jq -e . &>/dev/null; then
      monthly_cost=$(echo "$monthly_raw" | jq -r '.monthly[-1].totalCost // 0' 2>/dev/null)
      if [ "$(echo "$monthly_cost > 0" | bc 2>/dev/null)" = "1" ]; then
        cost_parts="${cost_parts:+${cost_parts} }${LAVENDER}M\$$(printf '%.0f' "$monthly_cost")${RESET}"
      fi
    fi

    if [ -n "$cost_parts" ]; then
      usage_info="$cost_parts"
    fi
  fi

  # Fallback: use cost from stdin JSON
  if [ -z "$usage_info" ]; then
    session_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
    if [ "$(echo "$session_cost > 0" | bc 2>/dev/null)" = "1" ]; then
      usage_info="${GREEN}Session:\$$(printf '%.2f' "$session_cost")${RESET}"
    fi
  fi
fi

# --- Worktree ---
wt_info=""
wt_name=$(echo "$input" | jq -r '.worktree.name // empty')
if [ -n "$wt_name" ] && [ "$wt_name" != "null" ]; then
  wt_branch=$(echo "$input" | jq -r '.worktree.branch // empty')
  wt_info="${SAPPHIRE}wt:${wt_name}${wt_branch:+ (${wt_branch})}${RESET}"
fi

# === OUTPUT ===

# Separator
SEP="${SUBTEXT}│${RESET}"

# Line 1: [model] directory │ git branch+status
printf "${TEXT}[${model_display:-Claude}]${RESET} "
printf "${RED}${os_icon} ${PEACH}${cwd}${RESET}"
[ -n "$git_info" ] && printf " ${SEP} ${YELLOW}${git_info}${RESET}"
printf "\n"

# Line 2: context bar │ [worktree] │ usage info
line2=""
[ -n "$ctx_info" ] && line2="${ctx_info}"
[ -n "$wt_info" ] && line2="${line2:+${line2} ${SEP} }${wt_info}"
[ -n "$usage_info" ] && line2="${line2:+${line2} ${SEP} }${usage_info}"
if [ -n "$line2" ]; then
  printf "${line2}${RESET}\n"
fi
