{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    steam
    # wechat
    # typora
    # obs-studio
    clash-verge-rev
  ];
}
