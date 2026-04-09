# Minecraft Browser App (Docker + PUID/PGID + iGPU + Sunshine)

This repo runs **Minecraft Java Edition inside Docker** and exposes it to a browser using **Sunshine** (game streaming), not VNC.

It supports:

- **PUID / PGID** mapping
- persistent Prism / Minecraft / Sunshine data
- Intel or AMD iGPU passthrough
- browser-facing app-only UX
- auto-launching Minecraft directly when an instance exists

---

## Why PUID / PGID?

This repo follows the **LinuxServer-style** ownership model.

### Solved by PUID / PGID
- file ownership on mounted volumes
- persistent app data
- avoiding permission issues on host files

### NOT solved by PUID / PGID
- GPU device access

For GPU access, you still need:

```yaml
group_add:
  - "video_gid"
  - "render_gid"
