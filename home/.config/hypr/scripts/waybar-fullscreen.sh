#!/usr/bin/env bash
# Hide Waybar while at least one Hyprland client is fullscreen.
set -u

runtime_dir="${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR is required}/hypr"
socket="$runtime_dir/${HYPRLAND_INSTANCE_SIGNATURE:?HYPRLAND_INSTANCE_SIGNATURE is required}/.socket2.sock"
log_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"

mkdir -p "$runtime_dir" "$log_dir"
exec 9>"$runtime_dir/waybar-fullscreen.lock"
flock -n 9 || exit 0

update_waybar() {
    if hyprctl clients -j | jq -e 'any(.[]; .fullscreen != 0)' >/dev/null; then
        pkill -x waybar 2>/dev/null || true
    elif ! pgrep -x waybar >/dev/null; then
        waybar >>"$log_dir/waybar.log" 2>&1 &
    fi
}

update_waybar

# Recheck after events that can add, remove, or change fullscreen clients.
socat -U - UNIX-CONNECT:"$socket" | while IFS= read -r event; do
    case "$event" in
        fullscreen\>\>*|openwindow\>\>*|closewindow\>\>*) update_waybar ;;
    esac
done
