{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
		gcc
		cmake
		ninja
		clang-tools
		pkg-config
    jq
		cava
    yazi
    neovim
    lazygit
    fastfetch
    go-musicfox
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
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
      nrs = "sudo nixos-rebuild switch --flake ~/Documents/nix-dotfiles#space";
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
}

