#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_root="$repo_root/dotfiles"
[[ -d "$source_root" ]] || { echo "No exported dotfiles found. Run export-dotfiles.sh on the original T420 first." >&2; exit 1; }

mode="${1:---dry-run}"
case "$mode" in --dry-run|--apply) ;; *) echo "Usage: bash scripts/restore-dotfiles.sh [--dry-run|--apply]" >&2; exit 2;; esac

backup_root="$HOME/gntech-restore-backups/$(date +%Y%m%d-%H%M%S)"
count=0
while IFS= read -r -d '' file; do
  rel="${file#"$source_root"/}"
  case "$rel" in
    .config/*|.local/bin/gntech-*) ;;
    *) echo "SKIP unexpected path: $rel" >&2; continue ;;
  esac
  [[ -L "$file" ]] && { echo "SKIP symlink: $rel" >&2; continue; }
  target="$HOME/$rel"
  if [[ "$mode" == "--dry-run" ]]; then
    printf 'WOULD INSTALL %s%s\n' "$rel" "$([[ -e "$target" ]] && printf ' (backup existing)' || true)"
  else
    if [[ -e "$target" || -L "$target" ]]; then
      mkdir -p "$backup_root/$(dirname "$rel")"
      cp -a -- "$target" "$backup_root/$rel"
    fi
    mkdir -p "$(dirname "$target")"
    install -m "$(stat -c '%a' "$file")" -- "$file" "$target"
    printf 'INSTALLED %s\n' "$rel"
  fi
  count=$((count+1))
done < <(find "$source_root" -type f -print0)
echo "$count file(s) reviewed. Mode: $mode"
[[ "$mode" == "--apply" ]] && echo "Existing files backed up under: $backup_root"
