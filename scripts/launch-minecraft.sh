#!/bin/bash
set -e

INSTANCE_NAME="${MC_INSTANCE:-Vanilla}"
PRISM="/opt/prism/PrismLauncher.AppImage"

if [ -d "/home/gamer/.local/share/PrismLauncher/instances/${INSTANCE_NAME}" ]; then
  echo "[launch] launching Prism instance: ${INSTANCE_NAME}"
  exec gamescope -W 1920 -H 1080 -f -- \
    "$PRISM" -l "${INSTANCE_NAME}" --no-sandbox
fi

echo "[launch] no instance found, starting Prism for first-time setup"
exec gamescope -W 1920 -H 1080 -f -- \
  "$PRISM" --no-sandbox
