--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Ignore maximize requests from apps. Steam is excluded: its CEF login and
-- settings windows on Hyprland ≥0.56 enter a hide/show loop when maximize is
-- suppressed (https://github.com/Sn3akyy1/lucid/issues/55,
-- https://github.com/hyprwm/Hyprland/discussions/15566). RE2 has no
-- lookbehind, so the match is negated with the negative: prefix.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = "negative:^(steam)$" },

    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Steam CEF dialogs (login QR, settings, friends, …). Keep them floating so
-- the tiling layout does not fight their XWayland configure dance. The main
-- library window is titled "Steam" and is left alone.
hl.window_rule({
    name  = "float-steam-dialogs",
    match = {
        class = "^(steam)$",
        title = "negative:^(Steam)$",
    },

    float  = true,
    center = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name  = "float-lucid-settings",
    match = { class = "org.quickshell", title = "Lucid Settings" },

    float  = true,
    size   = "1180 800",
    center = true,
})

hl.window_rule({
    match = { class = "org.gnome.Calculator" },

    float  = true,
    size   = "200 400",
    center = true,
})

-- lucid's file choosers. the portal opens them with no parent window to hang
-- off, so they would tile. matched by the titles lucidprefs/pickfile.py and
-- the kde connect bridge pass, so the file manager itself is left alone
hl.window_rule({
    name  = "float-lucid-choosers",
    match = {
        class = "^(org\\.gnome\\.Nautilus|xdg-desktop-portal-gtk|xdg-desktop-portal-gnome|zenity|org\\.kde\\.kdialog|kdialog)$",
        title = "^(Choose an account picture|Choose a template|Choose a colour scheme|Export the palette|Add wallpaper|Send files|Send to .+)$",
    },

    float  = true,
    center = true,
})
