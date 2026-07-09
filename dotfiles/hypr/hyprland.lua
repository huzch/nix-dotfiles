local terminal = "foot"

-- hl.monitor({ output = "eDP-1", disabled = true })
hl.monitor({
  output = "DP-6",
  mode = "3840x2160@160",
  position = "auto",
  scale = "auto",
})

hl.on("hyprland.start", function()
  hl.exec_cmd(terminal)
  hl.exec_cmd("waybar & swaync & awww-daemon & hypridle")
  hl.exec_cmd("fcitx5 --replace -d")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("wl-clip-persist --clipboard regular --reconnect-tries 0")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("udiskie -t -a")
  -- hl.exec_cmd("hyprsunset -t 6000")
end)

hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("WEBKIT_DISABLE_DMABUF_RENDERER", "1")
hl.env("QT_SCALE_FACTOR", "1.5")
hl.env("GDK_SCALE", "2")

hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    col = {
      active_border = {
        colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
        angle = 45,
      },
      inactive_border = "rgba(595959aa)",
    },
    resize_on_border = true,
    allow_tearing = false,
    layout = "dwindle",
  },
  decoration = {
    rounding = 10,
    rounding_power = 2,
    active_opacity = 0.9,
    inactive_opacity = 0.8,
    shadow = {
      enabled = false,
    },
    blur = {
      enabled = true,
      size = 8,
      passes = 3,
      vibrancy = 0.1696,
    },
  },
  animations = {
    enabled = true,
  },
  dwindle = {
    -- pseudotile = true,
    preserve_split = true,
  },
  master = {
    new_status = "master",
  },
  misc = {
    force_default_wallpaper = 1,
    disable_hyprland_logo = true,
    -- vfr = true,
  },
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
    },
  },
  binds = {
    workspace_back_and_forth = false,
    allow_workspace_cycles = true,
  },
})

hl.curve("easeOutQuint", {
  type = "bezier",
  points = { { 0.23, 1 }, { 0.32, 1 } },
})
hl.curve("easeInOutCubic", {
  type = "bezier",
  points = { { 0.65, 0.05 }, { 0.36, 1 } },
})
hl.curve("linear", {
  type = "bezier",
  points = { { 0, 0 }, { 1, 1 } },
})
hl.curve("almostLinear", {
  type = "bezier",
  points = { { 0.5, 0.5 }, { 0.75, 1.0 } },
})
hl.curve("quick", {
  type = "bezier",
  points = { { 0.15, 0 }, { 0.1, 1 } },
})

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 10, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 10, bezier = "easeOutQuint", style = "slide top" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 10, bezier = "almostLinear", style = "slide top" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "slide top" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "slide top" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 10, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 10, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 10, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 6, bezier = "easeOutQuint", style = "slide bottom" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 4, bezier = "almostLinear", style = "slide top" })

hl.device({
  name = "epic-mouse-v1",
  sensitivity = 0,
})

require("bind")
require("rule")
