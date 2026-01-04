{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nix-dotfiles/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    color = "color";
    fastfetch = "fastfetch";
    mango = "mango";
    nvim = "nvim";
		rofi = "rofi";
    waybar = "waybar";
    rofi = "rofi";
    swaync = "swaync";
    wlogout = "wlogout";
  };
in
{
  home.username = "huzch";
  home.homeDirectory = "/home/huzch";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
		wlogout
    waybar
    rofi
    swww
    mpvpaper
    wlogout
    cliphist
    wl-clipboard
    hypridle
    hyprlock
    hyprpolkitagent
    swaynotificationcenter
    libnotify
    bibata-cursors
    neovim
    yazi
    lazygit
    fastfetch
		go-musicfox
		pwvucontrol
		networkmanagerapplet
		brave
    # vscode
    # clash-verge-rev
		# wechat
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
      PS1="%F{blue}%~%f"$'\n'"%F{green}➜ %f"

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
      if uwsm check may-start; then
        exec uwsm start default
      fi
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".local/share/fcitx5/rime/default.custom.yaml".source = link "${dotfiles}/rime/default.custom.yaml";

  # 配置文件链接
  xdg.configFile = (builtins.mapAttrs (name: value: {
    source = link "${dotfiles}/${value}";
    recursive = true;
  }) configs);
}
