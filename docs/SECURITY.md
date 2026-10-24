# Security and privacy checklist

This is a private repository, **not** a secret store. Before committing exported dotfiles:

1. Inspect `git diff --cached` and `git status`.
2. Search for passwords, API keys, tokens, Wi-Fi secrets, SSH private keys, cloud credentials, internal hostnames/IP addresses and user-specific paths.
3. Keep `~/.ssh`, browser profiles, clipboard history, authentication caches, and `~/.local/share` outside this repository.
4. Check whether scripts or configuration contain environment variables or embedded credentials.
5. Remove secrets **before the first commit**. If a secret was pushed, rotate it; deleting the file from a later commit does not erase history.
6. The exporter copies `~/.config` subtrees and `gntech-*` scripts only. Review these copies carefully; the exporter does not guarantee they contain no secrets.
7. Run `bash scripts/restore-dotfiles.sh --dry-run` before any restoration. Apply only to a test user/machine after review.

Do not add production GNTECH SSH credentials or keys to the repository.
