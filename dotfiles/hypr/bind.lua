local terminal = "foot"
local menu = "rofi -show drun"
local scripts = "~/.config/hypr/scripts"
local mainMod = "ALT"

local function bind(keys, dispatcher, flags)
  hl.bind(keys, dispatcher, flags or {})
end

bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
bind(mainMod .. " + Q", hl.dsp.window.close())
bind(mainMod .. " + M", hl.dsp.exec_cmd("wlogout -b 5"))
bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
bind("SUPER + R", hl.dsp.exec_cmd("pkill waybar && waybar"))
bind(mainMod .. " + W", hl.dsp.exec_cmd(scripts .. "/wallpaper.sh next"))
bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(scripts .. "/wallpaper.sh select"))
bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
bind(mainMod .. " + SLASH", hl.dsp.exec_cmd(scripts .. "/help.sh"))
bind(mainMod .. " + V", hl.dsp.exec_cmd(scripts .. "/clipboard.sh"))
bind(mainMod .. " + T", hl.dsp.exec_cmd(scripts .. "/toggle-float.sh"))
bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind(mainMod .. " + P", hl.dsp.exec_cmd(scripts .. "/screenshot.sh full"))
bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(scripts .. "/screenshot.sh area"))
bind(mainMod .. " + R", hl.dsp.exec_cmd(scripts .. "/record.sh full"))
bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(scripts .. "/record.sh area"))

bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))

bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "l" }))
bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "d" }))
bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "u" }))
bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "r" }))

for i = 1, 10 do
  local key = i % 10
  bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))
bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

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
