#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
echo "Updating tracked files from the current home directory. Review the diff afterward."
while IFS= read -r -d '' target; do
  relative="${target#"$repo_dir/home/"}"
  source="$HOME/$relative"
  [[ -f "$source" ]] && cp -a -- "$source" "$target"
done < <(find "$repo_dir/home" -type f -print0 | sort -z)

pacman -Qqe > "$repo_dir/packages/arch-explicit.txt"
pacman -Qqm > "$repo_dir/packages/arch-aur.txt"
command -v flatpak >/dev/null && flatpak list --app --columns=application > "$repo_dir/packages/flatpak-apps.txt" || true
command -v hyprpm >/dev/null && hyprpm list > "$repo_dir/packages/hyprpm-list.txt" || true
echo "Done. Run: git diff --stat && git diff"
