#!/usr/bin/env bash
set -u
log_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
mkdir -p "$log_dir"

# Start the wallpaper before the other desktop services.
if command -v hyprpaper >/dev/null && ! pgrep -u "$(id -u)" -x hyprpaper >/dev/null; then
    hyprpaper >>"$log_dir/hyprpaper.log" 2>&1 &
fi

systemctl --user start swaync.service

# Idle and suspend policy.  The conditional keeps startup working until the
# hypridle package has been installed.
if command -v hypridle >/dev/null && ! pgrep -u "$(id -u)" -x hypridle >/dev/null; then
    hypridle >>"$log_dir/hypridle.log" 2>&1 &
fi

for app in waybar copyq; do
    command -v "$app" >/dev/null || continue
    pgrep -u "$(id -u)" -x "$app" >/dev/null && continue
    if [[ "$app" == copyq ]]; then
        COPYQ_SESSION_COLOR="#e0e0e0" "$app" --start-server >>"$log_dir/$app.log" 2>&1 &
    else
        "$app" >>"$log_dir/$app.log" 2>&1 &
    fi
done

# Keep the bar out of the way for fullscreen clients (including games).
if command -v socat >/dev/null && command -v jq >/dev/null; then
    "$HOME/.config/hypr/scripts/waybar-fullscreen.sh" >>"$log_dir/waybar-fullscreen.log" 2>&1 &
fi
