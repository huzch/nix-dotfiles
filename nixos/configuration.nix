{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  # 引导加载器
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # 网络
  networking = {
    hostName = "space";
    networkmanager.enable = true;
    proxy.default = "http://192.168.24.124:7890";
  };

  # 时区
  time.timeZone = "Asia/Shanghai";

  # 语言与输入法
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          (fcitx5-rime.override { # Rime输入法
            rimeDataPkgs = [ rime-data rime-ice ]; # 拼音词库
          })
          fcitx5-nord # 皮肤
        ];
      };
    };
  };

  # 字体
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
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  # 窗口合成器
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # CPU/GPU管理
  services.thermald.enable = true; # 启用Intel温控服务
  services.power-profiles-daemon.enable = true; # 电源模式管理
  services.xserver.videoDrivers = [ "nvidia" ]; # 加载显卡驱动
  hardware = {
    graphics = { # 图形加速库
      enable = true;
      enable32Bit = true;
      #extraPackages = with pkgs; [
      #  intel-media-driver
      #  libva-nvidia-driver
      #];
    };
    cpu.intel.updateMicrocode = true; # Intel微码更新
    nvidia = {
      modesetting.enable = true;
      open = false; # 使用闭源驱动
      nvidiaSettings = true;
      nvidiaPersistenced = true; # 启用持久守护进程，减少显卡初始化时间
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = true;
    };
  };

  # 用户
  programs.zsh.enable = true;
  services.getty.autologinUser = "huzch";
  users.users.huzch = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # 系统软件包与环境变量
  nixpkgs.config.allowUnfree = true; # 允许闭源软件
  programs.nix-ld.enable = true; # FHS兼容
  environment = {
    systemPackages = with pkgs; [
      vim
      git
      wget
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
      # WLR_NO_HARDWARE_CURSORS = "1";
      # ELECTRON_OZONE_PLATFORM_HINT = "auto";
      NVD_BACKEND = "direct";
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };

  # nix设置
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 系统版本（首次安装）
  system.stateVersion = "25.05";
}
