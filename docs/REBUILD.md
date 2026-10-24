# GNTECH T420 — Rebuild guide

Source of truth: [GNTECH Notion rebuild runbook](https://app.notion.com/p/4035e3549e2e819ea948dc2297bd6402).

## Target

Arch Linux, X11, i3, Alacritty, Rofi, Polybar, Thunar, Dunst, picom XRender. Hardware: Lenovo ThinkPad T420 (Intel HD 3000, 8 GB RAM, 1600×900).

## Sequence

1. Install Arch Linux, network access, Xorg, i3 and a non-root user.
2. Install required packages; refer to the Notion guide for the reviewed package list.
3. On the **working T420**, run `scripts/export-dotfiles.sh` to collect the actual configurations into `dotfiles/`.
4. Review changes with `git diff` and scan for secrets and machine-specific data before committing.
5. On a fresh machine, manually restore reviewed configurations, adjusting home directory, monitor, battery, network and startup programs.
6. Validate i3 config with `i3 -C -c ~/.config/i3/config`; verify shortcuts and launcher scripts before enabling autostart.

## Known fixes

- USB partitions may have blank `TRAN`: detect USB on the parent disk, then enumerate partitions.
- GTK recently-used XBEL bookmarks: Python `tree.getroot().iter("bookmark")` (not a namespaced bookmark lookup).
- Rofi selection theme: explicitly style `element selected`, `element selected.normal`, and `element-text selected`.
- Recent Folders tracks paths opened by GNTECH's helper, not all browsing in Thunar.
- SMB integration intentionally skipped because no SMB share was reachable.
- SSH aliases not yet configured; never commit SSH private keys.

## Status

The exact dotfiles have **not yet been exported** from the T420. This repository currently contains documentation and an export helper, not a tested turnkey installer.
