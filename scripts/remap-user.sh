#!/bin/bash
set -e

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

echo "[user] requested PUID=${PUID} PGID=${PGID}"

CURRENT_UID="$(id -u gamer)"
CURRENT_GID="$(id -g gamer)"

# Update group first
if [ "$CURRENT_GID" != "$PGID" ]; then
  if getent group "$PGID" >/dev/null 2>&1; then
    EXISTING_GROUP="$(getent group "$PGID" | cut -d: -f1)"
    echo "[user] using existing group ${EXISTING_GROUP} (${PGID})"
    usermod -g "$PGID" gamer
  else
    echo "[user] remapping gamer group ${CURRENT_GID} -> ${PGID}"
    groupmod -g "$PGID" gamer
  fi
fi

# Update user UID
if [ "$CURRENT_UID" != "$PUID" ]; then
  if getent passwd "$PUID" >/dev/null 2>&1; then
    echo "[user] WARNING: UID ${PUID} already exists in container, skipping usermod"
  else
    echo "[user] remapping gamer user ${CURRENT_UID} -> ${PUID}"
    usermod -u "$PUID" gamer
  fi
fi

# Ensure home ownership
chown -R gamer:"$PGID" /home/gamer || true
chown -R gamer:"$PGID" /tmp/runtime-root /tmp/pulse || true

echo "[user] remap complete: $(id gamer)"
