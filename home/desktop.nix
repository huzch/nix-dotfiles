{ pkgs, ... }:

{
  home.packages = with pkgs; [
    waybar
    rofi
    swww
    mpvpaper
    wlogout
    grim
    slurp
    cliphist
    wl-clipboard
    wl-clip-persist
    hyprlock
    # hypridle
    hyprpolkitagent
    swaynotificationcenter
    libnotify
    bibata-cursors
    pwvucontrol
    networkmanagerapplet
  ];

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=20, Symbols Nerd Font:size=20";
        pad = "10x10 center";
      };
      colors = {
        alpha = 0.8;
      };
    };
  };
}
