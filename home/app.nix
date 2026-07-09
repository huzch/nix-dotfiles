{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    steam
    # qq
    # wechat
    # typora
    # obs-studio
    clash-verge-rev
  ];
}
