# Minecraft Browser App (Docker + iGPU + Sunshine)

This repo runs **Minecraft Java Edition inside a Docker container** and exposes it to a browser using **Sunshine** (low-latency game streaming), **not VNC**.

## Design goals

- Minecraft runs **inside the container**
- Uses your **host integrated GPU** via `/dev/dri`
- Browser sees **only the game app**, not a full desktop
- Auto-launches directly into Minecraft when a Prism instance exists
- Disables:
  - exclusive fullscreen
  - raw mouse input
- Feels closer to a **native browser app** than a remote desktop

---

## What this is (and isn't)

### This **is**
- self-hosted browser game streaming
- GPU-accelerated Minecraft in Docker
- app-only streaming

### This **is not**
- a true HTML5 Minecraft client
- noVNC
- "Linux desktop in a browser" as the intended UX

Minecraft Java is a desktop OpenGL app. The only sane browser-facing architecture is:
- run it in Linux
- render with GPU
- stream only the app surface

---

## Requirements

### Host
- Linux host
- Docker + Docker Compose
- Intel or AMD iGPU
- Working render nodes:
  - `/dev/dri/renderD128`
  - `/dev/dri/card0`

Optional (mostly AMD/ROCm-ish environments):
- `/dev/kfd`

### Check your group IDs

On the host, run:

```bash
getent group video
getent group render
