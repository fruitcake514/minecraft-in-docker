# Base image
FROM ubuntu:22.04

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV XDG_RUNTIME_DIR=/tmp/runtime-root
ENV PULSE_SERVER=unix:/tmp/pulse/native
ENV LIBGL_ALWAYS_SOFTWARE=0
ENV __GLX_VENDOR_LIBRARY_NAME=mesa
ENV vblank_mode=0

# Install core dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl jq unzip ca-certificates gnupg2 software-properties-common \
    xvfb x11-utils xdotool wmctrl xauth dbus-x11 openbox \
    mesa-utils libgl1-mesa-dri libegl1-mesa libgl1-mesa-glx libvulkan1 \
    libxrandr2 libxinerama1 libxcursor1 libxi6 libxext6 \
    libx11-6 libxrender1 libxtst6 libnss3 libasound2 \
    libpulse0 pulseaudio fonts-dejavu fonts-liberation \
    gosu passwd git unzip unzip curl || rm -rf /var/lib/apt/lists/*

# Install OpenJDK 21
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-21-jdk-headless && rm -rf /var/lib/apt/lists/*

# Install Gamescope & MangoHud
RUN add-apt-repository -y ppa:graphics-drivers/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends gamescope mangohud && \
    rm -rf /var/lib/apt/lists/*

# Install Sunshine
RUN ARCH=$(dpkg --print-architecture) && \
    wget -O /tmp/sunshine.deb https://github.com/LizardByte/Sunshine/releases/latest/download/sunshine-ubuntu-22.04-${ARCH}.deb && \
    apt-get update && apt-get install -y --no-install-recommends /tmp/sunshine.deb || apt-get install -f -y && \
    rm -f /tmp/sunshine.deb && rm -rf /var/lib/apt/lists/*

# Install PrismLauncher
RUN mkdir -p /opt/prism && \
    wget -O /opt/prism/PrismLauncher.AppImage \
        https://github.com/PrismLauncher/PrismLauncher/releases/latest/download/PrismLauncher-Linux-x86_64.AppImage && \
    chmod +x /opt/prism/PrismLauncher.AppImage

# Create internal user
ARG PUID=1000
ARG PGID=1000
RUN groupadd -g $PGID gamer && \
    useradd -u $PUID -g $PGID -m -s /bin/bash gamer && \
    mkdir -p /home/gamer/.config/sunshine \
             /home/gamer/.local/share/PrismLauncher \
             /home/gamer/.minecraft \
             /home/gamer/.cache \
             /tmp/runtime-root \
             /tmp/pulse && \
    chown -R gamer:gamer /home/gamer /tmp/runtime-root /tmp/pulse

# Copy scripts & configs
COPY entrypoint.sh /entrypoint.sh
COPY scripts /scripts
COPY config /config
RUN chmod +x /entrypoint.sh /scripts/*.sh

WORKDIR /home/gamer

# Entrypoint remaps PUID/PGID and launches Minecraft
ENTRYPOINT ["/entrypoint.sh"]
