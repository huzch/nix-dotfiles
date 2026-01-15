{
  disko.devices = {
    disk = { # 物理磁盘设备
      main = { # 主磁盘
        device = "/dev/nvme0n1"; # /dev/sda 或 /dev/nvme0n1 等
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = { # 引导分区
              priority = 1;
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = { # 交换分区
              priority = 2;
              size = "8G";
              content = {
                type = "swap";
                resumeDevice = true; # 启用休眠支持
              };
            };
            root = { # 根分区
              priority = 3;
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # 强制格式化
                subvolumes = {
                  "/root" = { # 根目录子卷
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/home" = { # Home 目录子卷 (数据与系统分离，方便快照)
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/nix" = { # Nix Store 子卷 (避免 Nix 垃圾占满快照)
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
