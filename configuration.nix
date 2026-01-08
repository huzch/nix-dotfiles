{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  # 引导加载器
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 网络
  networking.hostName = "space";
  networking.networkmanager.enable = true;

  # 时区
  time.timeZone = "Asia/Shanghai";

  # 语言
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          (fcitx5-rime.override {
            rimeDataPkgs = [ rime-ice, rime-data ];
          })
          librime-lua
          fcitx5-gtk
          fcitx5-nord
        ];
      };
    };
  };
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      inter # UI字体
      nerd-fonts.symbols-only # UI图标
      nerd-fonts.jetbrains-mono # 终端/代码字体
      noto-fonts-cjk-sans # 核心中文黑体 (思源黑体)
      noto-fonts-cjk-serif # 核心中文宋体 (思源宋体)
      noto-fonts-color-emoji # 彩色Emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        # 无衬线字体 (UI, 网页)
        sansSerif = [ "Inter" "Noto Sans CJK SC" "Noto Sans CJK TC" ];
        # 衬线字体 (文档阅读)
        serif = [ "Noto Serif" "Noto Serif CJK SC" "Noto Serif CJK TC" ];
        # 等宽字体 (终端, 代码)
        monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK SC" ];
        # Emoji
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
  

  # 音视频
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # 图形环境
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };
  hardware.graphics = {
    enable = true;
  };

  # 用户
  programs.zsh.enable = true;
  services.getty.autologinUser = "huzch";
  users.users.huzch = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # 系统软件包
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true; # FHS兼容
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];

  # nix设置
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 系统版本（首次安装）
  system.stateVersion = "25.05";
}
