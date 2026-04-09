#!/bin/bash
set -e

for i in {1..30}; do
  if [ -e /dev/dri/renderD128 ]; then
    echo "[gpu] render node detected"
    exit 0
  fi
  echo "[gpu] waiting for /dev/dri/renderD128..."
  sleep 1
done

echo "[gpu] WARNING: render node not found, continuing anyway"
exit 0
