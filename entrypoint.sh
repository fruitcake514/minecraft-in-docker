#!/bin/bash
set -e

export PUID="${PUID:-1000}"
export PGID="${PGID:-1000}"

# Map UID/GID
bash /scripts/remap-user.sh

exec gosu gamer bash -c '
export DISPLAY=:0
export XDG_RUNTIME_DIR=/tmp/runtime-root
export PULSE_SERVER=unix:/tmp/pulse/native

mkdir -p "$XDG_RUNTIME_DIR" /tmp/pulse
chmod 700 "$XDG_RUNTIME_DIR"

# Start headless X
Xvfb :0 -screen 0 1920x1080x24 +extension GLX +render -noreset &

# Start minimal window manager
fluxbox &

# Hide mouse cursor
unclutter &

# Start VNC server
x11vnc -display :0 -nopw -listen 0.0.0.0 -xkb -forever &

# Start noVNC for browser access
/opt/novnc/utils/launch.sh --vnc localhost:5900 --listen 8080 &

# Wait a few seconds for X server
sleep 5

# Start Minecraft/PrismLauncher
exec bash /scripts/launch-minecraft.sh
'
