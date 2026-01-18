{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
		steam
    vscode
    wechat
		clash-verge-rev
  ];
}
