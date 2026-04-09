# Base image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV XDG_RUNTIME_DIR=/tmp/runtime-root
ENV PULSE_SERVER=unix:/tmp/pulse/native
ENV LIBGL_ALWAYS_SOFTWARE=0
ENV __GLX_VENDOR_LIBRARY_NAME=mesa
ENV vblank_mode=0

# Core dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl jq unzip ca-certificates gnupg2 software-properties-common \
    xvfb x11-utils x11-xserver-utils xdotool wmctrl xauth dbus-x11 openbox \
    mesa-utils libgl1-mesa-dri libegl1-mesa libgl1-mesa-glx libvulkan1 \
    libxrandr2 libxinerama1 libxcursor1 libxi6 libxext6 \
    libx11-6 libxrender1 libxtst6 libnss3 libasound2 \
    libpulse0 pulseaudio fonts-dejavu fonts-liberation \
    gosu passwd git unzip ca-certificates || rm -rf /var/lib/apt/lists/*

# OpenJDK 21
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-21-jdk-headless && rm -rf /var/lib/apt/lists/*

# Sunshine (AppImage, avoids GLIBC issues)
RUN mkdir -p /opt/sunshine && \
    wget -O /opt/sunshine/Sunshine.AppImage \
      https://github.com/LizardByte/Sunshine/releases/latest/download/Sunshine-x86_64.AppImage && \
    chmod +x /opt/sunshine/Sunshine.AppImage

# PrismLauncher
RUN mkdir -p /opt/prism && \
    wget -O /opt/prism/PrismLauncher.AppImage \
      https://github.com/PrismLauncher/PrismLauncher/releases/latest/download/PrismLauncher-Linux-x86_64.AppImage && \
    chmod +x /opt/prism/PrismLauncher.AppImage

# Internal user with PUID/PGID
ARG PUID=1000
ARG PGID=1000
RUN groupadd -g $PGID gamer && \
    useradd -u $PUID -g $PGID -m -s /bin/bash gamer && \
    mkdir -p /home/gamer/.config/sunshine \
             /home/gamer/.local/share/PrismLauncher \
             /home/gamer/.minecraft \
             /home/gamer/.cache \
             /tmp/runtime-root \
             /tmp/pulse \
             /tmp/.X11-unix && \
    chown -R gamer:gamer /home/gamer /tmp/runtime-root /tmp/pulse /tmp/.X11-unix

# Scripts & entrypoint
COPY entrypoint.sh /entrypoint.sh
COPY scripts /scripts
COPY config /config
RUN chmod +x /entrypoint.sh /scripts/*.sh

WORKDIR /home/gamer
ENTRYPOINT ["/entrypoint.sh"]
