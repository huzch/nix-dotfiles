{ config, pkgs, userName, ... }:

let
  dotfiles = ../dotfiles;

  configs = {
    color = "color";
    fastfetch = "fastfetch";
    hypr = "hypr";
    nvim = "nvim";
    quickshell = "quickshell";
    waybar = "waybar";
    rofi = "rofi";
    swaync = "swaync";
    wlogout = "wlogout";
    yazi = "yazi";
  };
in
{
  imports = [
    ./desktop.nix
    ./shell.nix
    ./app.nix
  ];

  home.username = userName;
  home.homeDirectory = "/home/${userName}";
  home.stateVersion = "25.05";

  home.file.".local/share/fcitx5/rime/default.custom.yaml".source = "${dotfiles}/rime/default.custom.yaml";

  # 配置文件
  xdg.configFile = builtins.mapAttrs (name: value: {
    source = "${dotfiles}/${value}";
    recursive = true;
  }) configs;
}
