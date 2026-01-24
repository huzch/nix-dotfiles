{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
		steam
    vscode
    wechat
		typora
    obs-studio
		clash-verge-rev
  ];
}
