# ThinkPad T420 battery charging thresholds

## Verified hardware state (2026-10-24)

The user verified the following on BAT0 using `sudo tlp-stat -b`:

```text
charge_control_start_threshold = 96 [%]
charge_control_end_threshold   = 100 [%]
```

These are the driver's reported defaults, allowing a charge to 100%. Previously the hardware had 80/90 thresholds.

## TLP configuration: verification pending

Two TLP files previously had active 80/90 settings:

- `/etc/tlp.d/10-battery.conf`
- `/etc/tlp.d/99-gntech-battery.conf`

Instructions were provided to back up both files and comment out `START_CHARGE_THRESH_BAT0` and `STOP_CHARGE_THRESH_BAT0`, but the user has **not yet provided the configuration-check output**. Do not assume TLP will preserve the new hardware state until verified.

Check on T420:

```bash
sudo grep -RnE '^[[:space:]]*(START|STOP)_CHARGE_THRESH_BAT[0-9]+=' /etc/tlp.conf /etc/tlp.d/ 2>/dev/null || echo "No active charging thresholds configured"
sudo tlp-stat -b | grep -E 'charge_control_(start|end)_threshold'
```

If active entries still exist, back up their files and comment out the entries before running `sudo tlp start`, then check again.

The T420's AC adapter wattage was **not** exposed via the available Linux ACPI power_supply interface. Adapter label output voltage/current is needed to distinguish 65W from 90W.
