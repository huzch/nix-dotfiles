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
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk
    ];
    fcitx5.waylandFrontend = true; 
  };
  fonts.packages = with pkgs; [
    nerd-fonts.hack
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];

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