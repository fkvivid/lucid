#!/usr/bin/env bash
# Steam under Lucid / Hyprland ≥0.56.
#
# Steam's CEF login (QR) and settings windows hide and reappear in a loop when
# the client runs as a native Wayland app — a Hyprland XWayland configure
# regression, not a Lucid crash (lucid#55, hyprwm/Hyprland#15566). Unsetting
# WAYLAND_DISPLAY forces the whole client through XWayland so those dialogs
# stay put. /usr/bin/steam avoids recursing if this script is named "steam".
set -euo pipefail

STEAM_BIN="${LUCID_STEAM_BIN:-/usr/bin/steam}"
if [[ ! -x $STEAM_BIN ]]; then
    STEAM_BIN="$(command -v steam-runtime 2>/dev/null || true)"
fi
if [[ -z ${STEAM_BIN:-} || ! -x $STEAM_BIN ]]; then
    printf 'lucid steam: steam is not installed\n' >&2
    exit 127
fi

exec env -u WAYLAND_DISPLAY -u VK_ICD_FILENAMES "$STEAM_BIN" "$@"
