#!/bin/bash
set -e

MC_DIR="/home/gamer/.minecraft"
OPTIONS="$MC_DIR/options.txt"

if [ ! -f "$OPTIONS" ]; then
  echo "[patch] options.txt not found"
  exit 1
fi

cp /config/minecraft-options.txt "$OPTIONS"
echo "[patch] options.txt updated"
