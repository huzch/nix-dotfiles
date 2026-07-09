local terminal = "foot"
local menu = "rofi -show drun"
local scripts = "~/.config/hypr/scripts"
local main_mod = "ALT"

local function bind(keys, dispatcher, flags)
  hl.bind(keys, dispatcher, flags or {})
end

bind(main_mod .. " + Return", hl.dsp.exec_cmd(terminal))
bind(main_mod .. " + q", hl.dsp.window.close())
bind(main_mod .. " + m", hl.dsp.exec_cmd("wlogout -b 5"))
bind(main_mod .. " + space", hl.dsp.exec_cmd(menu))
bind("SUPER + r", hl.dsp.exec_cmd("pkill waybar && waybar"))
bind(main_mod .. " + w", hl.dsp.exec_cmd(scripts .. "/wallpaper.sh next"))
bind(main_mod .. " + SHIFT + w", hl.dsp.exec_cmd(scripts .. "/wallpaper.sh select"))
bind(main_mod .. " + n", hl.dsp.exec_cmd("swaync-client -t -sw"))
bind(main_mod .. " + slash", hl.dsp.exec_cmd(scripts .. "/help.sh"))
bind(main_mod .. " + v", hl.dsp.exec_cmd(scripts .. "/clipboard.sh"))
bind(main_mod .. " + t", hl.dsp.exec_cmd(scripts .. "/toggle-float.sh"))
bind(main_mod .. " + f", hl.dsp.window.fullscreen({ mode = "maximized" }))
bind(main_mod .. " + SHIFT + f", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind(main_mod .. " + p", hl.dsp.exec_cmd(scripts .. "/screenshot.sh full"))
bind(main_mod .. " + SHIFT + p", hl.dsp.exec_cmd(scripts .. "/screenshot.sh area"))
bind(main_mod .. " + r", hl.dsp.exec_cmd(scripts .. "/record.sh full"))
bind(main_mod .. " + SHIFT + r", hl.dsp.exec_cmd(scripts .. "/record.sh area"))

bind(main_mod .. " + h", hl.dsp.focus({ direction = "l" }))
bind(main_mod .. " + j", hl.dsp.focus({ direction = "d" }))
bind(main_mod .. " + k", hl.dsp.focus({ direction = "u" }))
bind(main_mod .. " + l", hl.dsp.focus({ direction = "r" }))

bind(main_mod .. " + SHIFT + h", hl.dsp.window.swap({ direction = "l" }))
bind(main_mod .. " + SHIFT + j", hl.dsp.window.swap({ direction = "d" }))
bind(main_mod .. " + SHIFT + k", hl.dsp.window.swap({ direction = "u" }))
bind(main_mod .. " + SHIFT + l", hl.dsp.window.swap({ direction = "r" }))

for i = 1, 10 do
  local key = i % 10
  bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

bind(main_mod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))
bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
