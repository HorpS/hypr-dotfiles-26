#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

if ! command -v pacman >/dev/null; then
  echo "This installer expects Arch Linux (pacman was not found)." >&2
  exit 1
fi

echo "Installing official Arch packages..."
grep -Ev '^(yay|yay-debug)$|^$' "$repo_dir/packages/arch-explicit.txt" | sudo pacman -S --needed -

if command -v yay >/dev/null && [[ -s "$repo_dir/packages/arch-aur.txt" ]]; then
  echo "Installing AUR packages..."
  yay -S --needed - < "$repo_dir/packages/arch-aur.txt"
fi

if [[ -s "$repo_dir/packages/flatpak-apps.txt" ]] && command -v flatpak >/dev/null; then
  echo "Flatpak applications were recorded but are not installed automatically."
  echo "Review packages/flatpak-apps.txt and install them with flatpak if needed."
fi

echo "Backing up conflicting files to $backup_dir"
mkdir -p "$backup_dir"
while IFS= read -r -d '' source; do
  relative="${source#"$repo_dir/home/"}"
  target="$HOME/$relative"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$backup_dir/$(dirname -- "$relative")"
    mv -- "$target" "$backup_dir/$relative"
  fi
  mkdir -p "$(dirname -- "$target")"
  cp -a -- "$source" "$target"
done < <(find "$repo_dir/home" -type f -print0 | sort -z)

find "$HOME/.config/hypr" "$HOME/.local/bin" "$HOME/scripts" -type f -name '*.sh' -exec chmod +x {} + 2>/dev/null || true
echo "Restore complete. Log out and back in, then verify Hyprland and audio settings."
