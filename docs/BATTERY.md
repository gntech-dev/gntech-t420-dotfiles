# ThinkPad T420 battery charging thresholds

## Verified hardware state (2026-10-24)

The user verified the following on BAT0 using `sudo tlp-stat -b`:

```text
charge_control_start_threshold = 96 [%]
charge_control_end_threshold   = 100 [%]
```

These are the driver's reported defaults, allowing a charge to 100%. Previously the hardware had 80/90 thresholds.

## TLP configuration: verified

Two TLP files previously had active 80/90 settings:

- `/etc/tlp.d/10-battery.conf`
- `/etc/tlp.d/99-gntech-battery.conf`

After commenting out the threshold settings, the user ran the configuration check and confirmed the exact output **`No active charging thresholds configured`** on 2026-10-24. No active START/STOP threshold entries were found in `/etc/tlp.conf` or `/etc/tlp.d/`. The hardware values 96/100 were separately verified. Persistence after a reboot has not yet been tested.

Check on T420:

```bash
sudo grep -RnE '^[[:space:]]*(START|STOP)_CHARGE_THRESH_BAT[0-9]+=' /etc/tlp.conf /etc/tlp.d/ 2>/dev/null || echo "No active charging thresholds configured"
sudo tlp-stat -b | grep -E 'charge_control_(start|end)_threshold'
```

If active entries still exist, back up their files and comment out the entries before running `sudo tlp start`, then check again.

The T420's AC adapter wattage was **not** exposed via the available Linux ACPI power_supply interface. Adapter label output voltage/current is needed to distinguish 65W from 90W.
