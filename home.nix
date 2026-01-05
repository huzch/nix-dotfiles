{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nix-dotfiles/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    fastfetch = "fastfetch";
    hypr = "hypr";
    nvim = "nvim";
    waybar = "waybar";
  };
in
{
  home.username = "huzch";
  home.homeDirectory = "/home/huzch";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    waybar
    rofi
    swww
    hypridle
    swaynotificationcenter
    neovim
    yazi
    lazygit
    fastfetch
		go-musicfox
		pwvucontrol
		networkmanagerapplet
		brave
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "huzch";
      email = "huzch123@gmail.com";
    };
  };

  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Macchiato";
    font = {
      name = "Hack Nerd Font";
      size = 18;
    };
    settings = {
      background_opacity = "0.8";
    };
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      c = "clear";
      ll = "ls -l";
      la = "ls -la";
      lg = "lazygit";
      ff = "fastfetch";
      vim = "nvim";
      nrs = "sudo nixos-rebuild switch --flake ~/nix-dotfiles#space";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initContent = ''
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
    '';

    profileExtra = ''
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec Hyprland
      fi
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # 配置文件链接
  xdg.configFile = builtins.mapAttrs (name: value: {
    source = link "${dotfiles}/${name}";
    recursive = true;
  }) configs;
}
