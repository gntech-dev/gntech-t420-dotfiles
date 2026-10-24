#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="$repo_root/docs/packages-explicit.txt"
if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman not found: run on Arch Linux." >&2; exit 1
fi
pacman -Qqe | LC_ALL=C sort > "$out"
echo "Wrote $out"
echo "Review this list before committing; it may include personal or machine-specific software."
