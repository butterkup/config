#!/bin/env sh

if xrandr --query | grep "eDP-1 connected (" >/dev/null; then
  xrandr --output eDP-1 --auto
  xrandr --output eDP-1 --primary
  xrandr --output eDP-1 --right-of DP-2
else
  xrandr --output eDP-1 --off
  xrandr --output DP-2 --primary
fi

