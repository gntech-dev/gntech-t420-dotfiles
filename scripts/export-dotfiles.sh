#!/usr/bin/env bash
set -euo pipefail

# Run on the working T420 from the root of this repository.
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
destination="$repo_root/dotfiles"
mkdir -p "$destination/.config" "$destination/.local/bin"

for directory in i3 polybar rofi dunst picom gtk-3.0 gtk-4.0 udiskie; do
    source_path="$HOME/.config/$directory"
    if [[ -d "$source_path" ]]; then
        cp -a "$source_path" "$destination/.config/"
        printf 'Copied %s\n' "$source_path"
    fi
done

# Copy GNTECH-owned scripts only; do not export arbitrary executables.
shopt -s nullglob
for script in "$HOME"/.local/bin/gntech-*; do
    [[ -f "$script" ]] || continue
    cp -a "$script" "$destination/.local/bin/"
    printf 'Copied %s\n' "$script"
done

printf '\nExported to: %s\n' "$destination"
printf '%s\n' 'STOP: review every file for passwords, tokens, private paths, hostnames and other sensitive data before git add/commit/push.'
printf '%s\n' 'No SSH keys or ~/.ssh/config are collected by this script.'
