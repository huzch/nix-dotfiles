local function floating_rule(name, class, size)
  hl.window_rule({
    name = name,
    match = { class = class },
    float = true,
    size = size,
    center = true,
  })
end

floating_rule("float-pwvucontrol", "com.saivert.pwvucontrol", { 800, 600 })
floating_rule("float-nm-connection-editor", "nm-connection-editor", { 800, 600 })
floating_rule("float-blueman-manager", ".blueman-manager-wrapped", { 800, 600 })
floating_rule("float-fcitx", "org.fcitx.", { 800, 600 })
floating_rule("float-clash", "clash-verge", { 900, 700 })
floating_rule("float-xdg-desktop-portal-gtk", "xdg-desktop-portal-gtk", { 800, 600 })

hl.window_rule({
  name = "float-wechat-menu",
  match = {
    class = "wechat",
    title = "wechat",
  },
  border_size = 0,
  no_anim = true,
  no_blur = true,
})

hl.window_rule({
  name = "float-wechat",
  match = { title = "微信" },
  float = true,
  size = { 900, 700 },
  center = true,
  no_anim = true,
})

hl.window_rule({
  name = "float-wechat-setting",
  match = {
    class = "wechat",
    title = "设置",
  },
  float = true,
  size = { 600, 500 },
  center = true,
  no_anim = true,
})

hl.window_rule({
  name = "disable-blur-menus",
  match = {
    class = "^$",
    title = "^$",
  },
  no_blur = true,
})
