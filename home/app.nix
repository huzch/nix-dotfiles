{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    # vscode
    # wechat
    # clash-verge-rev
  ];
}
