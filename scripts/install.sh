#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mode="dry-run"
install_packages=false
restore_dotfiles=false

usage() {
  cat <<'USAGE'
GNTECH T420 Desktop Installer v0.1
Usage: bash scripts/install.sh [--dry-run|--apply] [--packages] [--dotfiles]

Defaults to dry-run, both components selected.
  --dry-run   Preview operations (default)
  --apply     Execute selected operations
  --packages  Install missing desktop packages
  --dotfiles  Restore exported dotfiles (backups created by restore script)
  --help      Show this help

This installer does not partition disks, install a bootloader, or configure
display managers. Run as a regular user on an existing Arch installation.
USAGE
}

while (($#)); do
  case "$1" in
    --dry-run) mode="dry-run" ;;
    --apply) mode="apply" ;;
    --packages) install_packages=true ;;
    --dotfiles) restore_dotfiles=true ;;
    --help|-h) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

if [[ "$install_packages" == false && "$restore_dotfiles" == false ]]; then
  install_packages=true
  restore_dotfiles=true
fi

[[ $(id -u) -ne 0 ]] || { echo "Run as your regular user, not root." >&2; exit 1; }
command -v pacman >/dev/null || { echo "Arch Linux/pacman required." >&2; exit 1; }

# Desktop-specific packages only. Deliberately excludes kernel, base, boot,
# firmware, and other host-specific entries from packages-explicit.txt.
packages=(
  alacritty brightnessctl btop clipmenu dunst feh file-roller
  gnome-themes-extra gvfs gvfs-mtp gvfs-smb i3-wm i3lock
  maim network-manager-applet noto-fonts noto-fonts-emoji
  papirus-icon-theme pavucontrol picom pipewire pipewire-pulse
  playerctl polkit-gnome polybar rofi slop thunar
  thunar-archive-plugin thunar-volman ttf-dejavu
  ttf-jetbrains-mono-nerd tumbler udiskie wireplumber xclip
  xdg-user-dirs xdg-utils xdotool xorg-server xorg-xinit
  xorg-xrandr xorg-xset xss-lock
)

missing=()
if [[ "$install_packages" == true ]]; then
  for package in "${packages[@]}"; do
    if ! pacman -Qq "$package" >/dev/null 2>&1; then
      missing+=("$package")
    fi
  done
  printf 'Desktop packages selected: %d; missing: %d\n' "${#packages[@]}" "${#missing[@]}"
  if (("${#missing[@]}" > 0)); then
    printf 'Missing: %s\n' "${missing[*]}"
  fi
fi

if [[ "$mode" == "dry-run" ]]; then
  echo "DRY RUN: no changes will be made."
  if [[ "$restore_dotfiles" == true ]]; then
    bash "$repo_root/scripts/restore-dotfiles.sh" --dry-run
  fi
  exit 0
fi

if [[ "$install_packages" == true ]] && (("${#missing[@]}" > 0)); then
  sudo pacman -S --needed -- "${missing[@]}"
fi
if [[ "$restore_dotfiles" == true ]]; then
  bash "$repo_root/scripts/restore-dotfiles.sh" --apply
fi
echo "GNTECH installer finished. Log out and back in if desktop settings changed."
