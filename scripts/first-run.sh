#!/bin/bash
set -e

MC_DIR="/home/gamer/.minecraft"
OPTIONS="$MC_DIR/options.txt"

mkdir -p "$MC_DIR"

echo "[minecraft] waiting for options.txt..."

for i in {1..300}; do
  if [ -f "$OPTIONS" ]; then
    cp /config/minecraft-options.txt "$OPTIONS"
    echo "[minecraft] patched options.txt"
    exit 0
  fi
  sleep 2
done

echo "[minecraft] options.txt not found in time"
exit 0
