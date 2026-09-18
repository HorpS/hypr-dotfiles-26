<img width="1920" height="1080" alt="2026-09-18-214657_hyprshot" src="https://github.com/user-attachments/assets/2a2db84c-c479-460d-8fdd-7f6aa79c61ed" />
<img width="1920" height="1080" alt="2026-09-18-214608_hyprshot" src="https://github.com/user-attachments/assets/a5063b26-af44-4ba9-a398-fad2d17226d1" />
# Horp's Linux dotfiles

This repository contains reproducible user configuration for an Arch Linux desktop using Hyprland, Waybar, SwayNC, KDE applications, Alacritty, Wofi, GTK, and shell tools.

It intentionally does **not** contain passwords, SSH keys, browser profiles, clipboard history, databases, caches, logs, Steam state, or wallpaper files. Back those up separately if needed.

## Before reinstalling

1. Push this repository to a **private** GitHub repository.
2. Save personal data separately: `Documents`, `Pictures`, `Downloads/Wallpapers`, browser bookmarks/passwords, and any SSH keys or application exports you actually need.
3. Export secrets from your password manager. Do not put them in this repository.
4. Record disk layout and encryption/recovery keys separately.

## Restore after installing Arch Linux

```bash
sudo pacman -S --needed git
git clone https://github.com/REPLACE_ME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` installs recorded official packages, installs AUR packages when `yay` is available, and copies tracked files into `$HOME`. Existing files are backed up to `~/.dotfiles-backup-<timestamp>`.

Afterward, restore your own wallpaper and point the Hyprland configs at it:

```bash
ln -sfn "$HOME/Downloads/Wallpapers/your-wallpaper.jpg" "$HOME/.config/hypr/current-wallpaper"
```

The HyprGlass plugin is not vendored. Reinstall it from its upstream repository using its current instructions, then enable it with `hyprpm`; verify the upstream URL before running any install command.

## Included

- Shell startup files and helper scripts
- Hyprland, Hyprlock, Hypridle, Hyprpaper, and helper scripts
- Waybar, SwayNC, Wofi, Alacritty, GTK, htop, EasyEffects, and selected KDE settings
- Official Arch, AUR, and Hyprpm package manifests

## Deliberately excluded

Firefox profiles and passwords, SSH private keys and `known_hosts`, CopyQ clipboard history, PulseAudio/WirePlumber state, KDE/Accounts databases, session restore files, logs, caches, Steam data, and wallpaper assets.

## Updating the backup

```bash
./backup-current.sh
git status
git diff
git add .
git commit -m "Update desktop configuration"
git push
```
