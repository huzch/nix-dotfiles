{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nix-dotfiles/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    color = "color";
    fastfetch = "fastfetch";
    hypr = "hypr";
    nvim = "nvim";
    waybar = "waybar";
    rofi = "rofi";
    swaync = "swaync";
    wlogout = "wlogout";
  };
in
{
  imports = [
    ./desktop.nix
    ./shell.nix
    ./app.nix
  ];

  home.username = "huzch";
  home.homeDirectory = "/home/huzch";
  home.stateVersion = "25.05";

  home.file.".local/share/fcitx5/rime/default.custom.yaml".source = link "${dotfiles}/rime/default.custom.yaml";

  # 配置文件链接
  xdg.configFile = (builtins.mapAttrs (name: value: {
    source = link "${dotfiles}/${value}";
    recursive = true;
  }) configs);
}
