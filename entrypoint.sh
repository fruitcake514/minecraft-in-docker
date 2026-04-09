#!/bin/bash
set -e

export PUID="${PUID:-1000}"
export PGID="${PGID:-1000}"

bash /scripts/remap-user.sh

exec gosu gamer bash -c '
  export DISPLAY=:0
  export XDG_RUNTIME_DIR=/tmp/runtime-root
  export PULSE_SERVER=unix:/tmp/pulse/native

  # Ensure required dirs exist
  mkdir -p "$XDG_RUNTIME_DIR" /tmp/pulse /tmp/.X11-unix
  chmod 700 "$XDG_RUNTIME_DIR" /tmp/pulse /tmp/.X11-unix

  bash /scripts/wait-for-gpu.sh

  pulseaudio --daemonize=yes --exit-idle-time=-1 --log-target=stderr || true

  Xvfb :0 -screen 0 1920x1080x24 +extension GLX +render -noreset &
  sleep 2

  xset -dpms || true
  xset s off || true
  xset s noblank || true

  openbox &
  sleep 2

  mkdir -p /home/gamer/.config/sunshine
  cp -n /config/sunshine.conf /home/gamer/.config/sunshine/sunshine.conf || true
  cp -n /config/apps.json /home/gamer/.config/sunshine/apps.json || true

  # Run Sunshine AppImage
  /opt/sunshine/Sunshine.AppImage &

  sleep 5
  bash /scripts/first-run.sh &

  exec bash /scripts/launch-minecraft.sh
'
