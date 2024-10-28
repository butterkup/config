#!/bin/env sh

{
  chbgpidfile="$HOME/.local/share/chbg.pid"
  if [ -e "$chbgpidfile" ]; then
    kill -s SIGTERM "$(<"$chbgpidfile")" 2>/dev/null
    rm -f "$chbgpidfile"
  fi
  CHBGFAST=yes CHBGWAIT=20m CHBGSEL=random_shuffle CHBGPID="$chbgpidfile" chbg
} &

xset -b -c # disable bells

if [[ $(xrandr --listactivemonitors | wc -l) -gt 2 ]]; then
  xrandr --output DP-2 --primary
  xrandr --output eDP-1 --off
fi 

picom --fade-delta 5 --backend glx --fading --vsync --daemon

