#!/bin/bash
hostname=$(hostname)
set_walpaper() {
  feh --randomize --bg-fill ~/Pictures/wallpaper
}
if [ "$hostname" == "redeye" ]; then # pc
  xrandr \
    --output HDMI-0 --mode 1920x1080 --pos 1920x1080 --rotate normal \
    --output DP-2 --primary --mode 1920x1080 --refresh 144 --pos 0x1080 --rotate normal \
    --output DP-1 --mode 1920x1080 --pos 1920x0 --rotate normal \
    --output DP-0 --off --output DP-3 --off --output DP-4 --off --output DP-5 --off

  set_walpaper
else
  set_walpaper
fi
xset s off -dpms
xset r rate 250 15
source ~/.scripts/autostart.sh
