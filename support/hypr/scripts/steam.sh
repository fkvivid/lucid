#!/usr/bin/env bash
# Steam under Lucid / Hyprland.
#
# Two separate bugs produce the same "opens then vanishes / loops" symptom:
#
# 1) Hyprland ≥0.56 + native Wayland Steam: CEF login/settings hide-loop
#    (lucid#55, hyprwm/Hyprland#15566). Unset WAYLAND_DISPLAY → XWayland.
#
# 2) DRI_PRIME offload (often injected because steam.desktop sets
#    PrefersNonDefaultGPU=true): steamwebhelper crash-loops after the splash
#    (ValveSoftware/steam-for-linux#9383). Unset DRI_PRIME so CEF uses the
#    default GPU; games can still pick the dGPU via Vulkan/DXVK.
#
# /usr/bin/steam avoids recursing if this script is on PATH as "steam".
set -euo pipefail

STEAM_BIN="${LUCID_STEAM_BIN:-/usr/bin/steam}"
if [[ ! -x $STEAM_BIN ]]; then
    STEAM_BIN="$(command -v steam-runtime 2>/dev/null || true)"
fi
if [[ -z ${STEAM_BIN:-} || ! -x $STEAM_BIN ]]; then
    printf 'lucid steam: steam is not installed\n' >&2
    exit 127
fi

exec env -u WAYLAND_DISPLAY -u VK_ICD_FILENAMES -u DRI_PRIME \
    "$STEAM_BIN" "$@"
