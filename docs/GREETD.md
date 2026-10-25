# GNTECH greetd graphical login — T420

## Verified baseline
On the original ThinkPad T420, greetd + tuigreet + startx successfully authenticated and launched i3. The user .xinitrc imports DISPLAY/XAUTHORITY and ends with exec i3. The graphical Cage + gtkgreet path is **not yet verified** on Intel HD 3000.

## Preview
```bash
bash scripts/install.sh --dry-run --greetd
bash scripts/configure-greetd.sh --dry-run --graphical
```

## Apply (only after review)
Keep a recovery TTY enabled: `sudo systemctl enable --now getty@tty2.service`.
```bash
bash scripts/install.sh --apply --greetd
```
This backs up /etc/greetd/config.toml under /etc/greetd/gntech-backups, installs packages and writes the graphical greeter configuration. It does not restart greetd. Reboot separately after verifying recovery access. The X11 i3 session continues through startx and ~/.xinitrc.

## Recover if graphical greeter fails
Switch to Ctrl+Alt+F2, log in and from the repo run:
```bash
bash scripts/configure-greetd.sh --apply --rollback
sudo reboot
```
If that script is unavailable, restore a backup from /etc/greetd/gntech-backups or disable greetd and re-enable getty@tty1.

## Caution
Cage uses Wayland for the greeter, while i3 uses X11. The old Intel HD 3000 GPU may not support this reliably. Test before treating graphical login as a supported T420 default. The repository does not yet include a GTK theme or wallpaper for gtkgreet.
