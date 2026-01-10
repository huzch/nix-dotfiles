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
    swaync = "swaync";
    waybar = "waybar";
    wlogout = "wlogout";
    quickshell = "quickshell";
  };
in
{
  home.username = "huzch";
  home.homeDirectory = "/home/huzch";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    quickshell # 桌面 Shell 框架
    waybar # 状态栏
    rofi # 应用启动器
    swww # 壁纸管理
    mpvpaper # 动态壁纸
    wlogout # 关机菜单
		wlr-randr # 显示器管理
		wlrctl # 显示器控制
		wlopm # 电源管理
    grim # 截图工具
    slurp # 选择区域截图
    cliphist # 剪贴板管理
    wl-clipboard # 剪贴板工具
    wl-clip-persist # 剪贴板持久化
    swaylock-effects # 锁屏效果
    swayidle # 屏幕闲置管理
    swaynotificationcenter # 通知中心
    libnotify # 通知库
    bibata-cursors # 光标主题
    neovim # 文本编辑器
    yazi # 文件管理器
    lazygit # Git 界面工具
    fastfetch # 系统信息工具
		go-musicfox # 音乐播放器
		pwvucontrol # 音量控制
		networkmanagerapplet # 网络管理
		brave # 浏览器
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
      exec mango
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
