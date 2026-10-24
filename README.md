# GNTECH ThinkPad T420 Dotfiles

Private repository for reproducing the GNTECH Arch Linux X11/i3 desktop.

## Contents

- [`docs/REBUILD.md`](docs/REBUILD.md): rebuild sequence, requirements and known fixes.
- [`scripts/export-dotfiles.sh`](scripts/export-dotfiles.sh): copies selected desktop configuration from the working T420 into `dotfiles/`.
- [Detailed Notion runbook](https://app.notion.com/p/4035e3549e2e819ea948dc2297bd6402).

## On the working T420

```bash
git clone https://github.com/gntech-dev/gntech-t420-dotfiles.git
cd gntech-t420-dotfiles
bash scripts/export-dotfiles.sh
git status --short
```

Authentication is required for this private repository. **Review the exported files for secrets, tokens, internal IPs, private paths and personal data before committing or pushing.** SSH private keys are not collected.

## Status

The repository contains initial documentation and an export helper. The exact T420 dotfiles have **not** been exported yet. A tested clean-install automation will follow after those files are reviewed and validated.
