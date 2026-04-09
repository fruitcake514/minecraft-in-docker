# Base image
FROM ubuntu:22.04

# Environment
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
    xvfb x11-utils xdotool wmctrl xauth dbus-x11 openbox fluxbox \
    mesa-utils libgl1-mesa-dri libegl1-mesa libgl1-mesa-glx libvulkan1 \
    libxrandr2 libxinerama1 libxcursor1 libxi6 libxext6 \
    libx11-6 libxrender1 libxtst6 libnss3 libasound2 \
    libpulse0 pulseaudio fonts-dejavu fonts-liberation \
    gosu passwd git unzip x11vnc novnc websockify unclutter \
    openjdk-21-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

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
    mkdir -p /home/gamer/.local/share/PrismLauncher \
             /home/gamer/.minecraft \
             /home/gamer/.cache \
             /tmp/runtime-root \
             /tmp/pulse && \
    chown -R gamer:gamer /home/gamer /tmp/runtime-root /tmp/pulse

# Scripts & entrypoint
COPY entrypoint.sh /entrypoint.sh
COPY scripts /scripts
COPY config /config
RUN chmod +x /entrypoint.sh /scripts/*.sh

WORKDIR /home/gamer

ENTRYPOINT ["/entrypoint.sh"]
