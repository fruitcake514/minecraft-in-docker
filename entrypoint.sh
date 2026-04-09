#!/bin/bash
set -e

export DISPLAY=:0
export XDG_RUNTIME_DIR=/tmp/runtime-root
export PULSE_SERVER=unix:/tmp/pulse/native

mkdir -p "$XDG_RUNTIME_DIR" /tmp/pulse
chmod 700 "$XDG_RUNTIME_DIR"

bash /scripts/wait-for-gpu.sh

# PulseAudio
pulseaudio --daemonize=yes --exit-idle-time=-1 --log-target=stderr || true

# Virtual X display
Xvfb :0 -screen 0 1920x1080x24 +extension GLX +render -noreset &
sleep 2

# Prevent blanking
xset -dpms || true
xset s off || true
xset s noblank || true

# Minimal WM (keeps app sane without exposing "desktop" as the UX)
openbox &
sleep 2

# Seed Sunshine config if not already persisted
mkdir -p /home/gamer/.config/sunshine
cp -n /config/sunshine.conf /home/gamer/.config/sunshine/sunshine.conf || true
cp -n /config/apps.json /home/gamer/.config/sunshine/apps.json || true

# Start Sunshine (inside the same container as Minecraft)
sunshine &
sleep 5

# Patch MC options once the game writes them
bash /scripts/first-run.sh &

# Launch app surface (Minecraft instance if present, Prism only if needed)
exec bash /scripts/launch-minecraft.sh
