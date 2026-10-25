#!/usr/bin/env bash
set -euo pipefail

mode=dry-run
action=graphical
for arg in "$@"; do
  case "$arg" in
    --dry-run) mode=dry-run ;;
    --apply) mode=apply ;;
    --graphical) action=graphical ;;
    --rollback) action=rollback ;;
    -h|--help) echo "Usage: bash scripts/configure-greetd.sh [--dry-run|--apply] [--graphical|--rollback]"; exit 0 ;;
    *) echo "Unknown argument: $arg" >&2; exit 2 ;;
  esac
done

[[ $(id -u) != 0 ]] || { echo "Run as regular user." >&2; exit 1; }
config=/etc/greetd/config.toml
backup_dir=/etc/greetd/gntech-backups
gtk_command="cage -s -- gtkgreet -l -c 'startx'"
tty_command="tuigreet --time --remember --cmd startx"

if [[ "$action" == rollback ]]; then
  echo "Rollback target: $tty_command"
else
  echo "Graphical target: $gtk_command"
fi
echo "Current configuration:"
if [[ -r "$config" ]]; then cat "$config"; else sudo cat "$config" 2>/dev/null || true; fi
echo "greetd enabled: $(systemctl is-enabled greetd.service 2>/dev/null || true)"
echo "Recovery tty2: $(systemctl is-enabled getty@tty2.service 2>/dev/null || true)"
if [[ "$mode" == dry-run ]]; then
  echo "DRY RUN: would install greetd greetd-tuigreet xorg-server xorg-xinit i3-wm"
  [[ "$action" == graphical ]] && echo "DRY RUN: would additionally install cage greetd-gtkgreet"
  echo "DRY RUN: would back up current config, replace it, and leave greetd running state unchanged."
  exit 0
fi

[[ -f "$config" ]] || { echo "Missing $config; set up and test tuigreet first." >&2; exit 1; }
[[ -f "$HOME/.xinitrc" ]] || { echo "Missing ~/.xinitrc; cannot launch desktop with startx." >&2; exit 1; }
systemctl is-enabled --quiet getty@tty2.service || { echo "Enable recovery TTY first: sudo systemctl enable --now getty@tty2.service" >&2; exit 1; }

if [[ "$action" == graphical ]]; then
  sudo pacman -S --needed greetd greetd-tuigreet cage greetd-gtkgreet xorg-server xorg-xinit i3-wm
  command -v cage >/dev/null && command -v gtkgreet >/dev/null || { echo "Graphical greeter executables unavailable." >&2; exit 1; }
  target="$gtk_command"
else
  sudo pacman -S --needed greetd greetd-tuigreet
  target="$tty_command"
fi

sudo install -d -m 700 "$backup_dir"
stamp="$(date +%Y%m%d-%H%M%S)"
sudo cp -a "$config" "$backup_dir/config.toml.$stamp"
echo "Backup: $backup_dir/config.toml.$stamp"
printf '[terminal]\nvt = 1\n\n[default_session]\ncommand = "%s"\nuser = "greeter"\n' "$target" | sudo tee "$config" >/dev/null
echo "Configuration updated; greetd was NOT restarted. Reboot only when ready."
echo "Recovery: Ctrl+Alt+F2, log in, then bash scripts/configure-greetd.sh --apply --rollback"
