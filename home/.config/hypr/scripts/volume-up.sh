#!/usr/bin/env bash
set -euo pipefail
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F/ 'NR == 1 { gsub(/[^0-9]/, "", $2); print $2 }')
[[ "$volume" =~ ^[0-9]+$ ]] || exit 1
target=$((volume + 5))
(( target > 100 )) && target=100
pactl set-sink-volume @DEFAULT_SINK@ "${target}%"
