## 概览 (Overview)
![Desktop Screenshot](./space.png)
<!-- 如果想添加截图：可以创建一个 issue，将图片拖拽进去，然后将生成的链接复制到这里 -->

> **欢迎来到 nix-dotfiles！** 本指南专为新手准备，尽量通俗易懂地带你完成 NixOS 环境和美化配置的搭建。

---

## ⚠️ 必读：注意事项与个性化配置
由于 NixOS 是一个基于声明式的系统，这意味着你需要**在执行安装脚本之前**，把配置文件中的示例名字和硬件信息换成你自己的！

请务必提前修改以下几个文件，根据你的个人情况进行调整：

### 1. 磁盘分区配置 (`nixos/disko.nix`)
你需要根据你的实际硬盘名称和类型修改文件。你可以通过运行 `lsblk` 命令来查看你的硬盘名称（例如 `nvme0n1` 或 `sda`）。
```nix
# nixos/disko.nix 示例：
device = "/dev/nvme0n1"; # 如果你的主硬盘是 sda，请将其改为 "/dev/sda"
```

### 2. 系统核心配置 (`flake.nix`)
这里定义了系统的入口，必须将默认的用户名（`huzch`）和主机名（`space`）换成你想要的名称。
```nix
# flake.nix 示例：
nixosConfigurations = {
  # "space" 是你这台电脑的配置名称，你可以改成 "my-laptop" 或其他名字
  space = nixpkgs.lib.nixosSystem { 
    system = "x86_64-linux"; # 你的 CPU 架构，通常普通电脑都是 x86_64-linux
    # ...
  };
};

# ⚠️ 非常重要：如果你是在 U盘 (Live ISO) 环境下首次安装，
# 请务必在此处将引入 home-manager 的行注释掉（在前面加 # 号）！
# # users.huzch = import ./home; 
```

### 3. 系统级配置 (`nixos/configuration.nix`)
这里设置你的主机名、时区、以及是否开启显卡/硬件加速等系统级功能。
当前配置默认是针对 **Intel CPU + Nvidia GPU** 的环境。如果你使用的是其他硬件，请按照以下说明进行修改：

```nix
# nixos/configuration.nix 示例：
networking.hostName = "space"; # 这个名字需要和 flake.nix 里的配置名对应

# --- 硬件与驱动配置说明 ---
# 1. CPU 微代码更新 (根据你的 CPU 选择其一，注释掉另一个)
hardware.cpu.intel.updateMicrocode = true; # 如果是 Intel CPU
# hardware.cpu.amd.updateMicrocode = true; # 如果是 AMD CPU，请取消这行注释并注释掉上一行

# 2. 显卡驱动配置
# 默认配置适用于 Nvidia 独显。如果你使用的是 AMD 显卡或核显，请调整对应的驱动设置：
# - AMD GPU 或 Intel/AMD 核显用户：通常只需要包含内核自带的开源驱动（mesa 等），
#   你需要将配置中专门针对 nvidia 的设置项（如 services.xserver.videoDrivers = [ "nvidia" ] 等相关段落）进行注释或删除。
# - 对于 AMD GPU，你可以确保启用了 amdgpu 驱动：
#   services.xserver.videoDrivers = [ "amdgpu" ];
```

### 4. 用户级配置 (`home/default.nix`)
设置你的个人账号信息。
```nix
# home/default.nix 示例：
home.username = "huzch"; # 换成你的用户名
home.homeDirectory = "/home/huzch"; # 换成对应的主目录路径
```

### 5. 一键安装脚本 (`init.sh`)
虽然脚本是一键执行的，但你也需要打开 `init.sh`，将其中的默认配置名 `space` 和用户名 `huzch` 全都替换成你自己的名字，否则脚本会报错或安装到错误的路径下。
```bash
# init.sh 示例，请把里面的 space 和 huzch 都换成你自己的：
nixos-install --flake /mnt/etc/nixos#space
nixos-enter --root /mnt -c 'passwd huzch'
```

### 6. 网络与代理配置 (Proxy Settings)
由于国内网络原因，安装 NixOS 和拉取各种配置（如 GitHub 仓库、Nix 缓存）需要畅通的网络。我们将其分为两个阶段：

- **阶段一：U盘 ISO 安装环境（执行 `init.sh` 时）**
  此时电脑上尚未安装系统和代理软件。你可以用**数据线将手机和电脑连接**，打开手机的“USB 网络共享”，并在手机上的 Clash（或其他代理工具）中开启“允许局域网连接 (Allow LAN)”。
  接着打开 `init.sh` 脚本，将其中的代理 IP 地址修改为你手机分享给电脑的网关 IP（通常是 `192.168.x.x` 系列，可以通过终端执行 `ip route` 查看），端口改为手机 Clash 的监听端口：
  ```bash
  # init.sh 示例：修改为你手机局域网共享的 IP 和端口
  export http_proxy="http://192.168.42.129:7890"
  export https_proxy="http://192.168.42.129:7890"
  ```

- **阶段二：进入 NixOS 新系统后**
  系统安装成功并重启后，你就可以拔掉数据线、彻底脱离手机了。此时你的电脑主系统上应该已经可以通过配置启动电脑版的 Clash。确保在 `nixos/configuration.nix` 中将系统代理直接指向你的电脑本地：
  ```nix
  # nixos/configuration.nix 示例：指向本地电脑的 Clash
  networking.proxy.default = "http://127.0.0.1:7890";
  ```

---

## 🚀 快速开始 (Quick Start)
> 由于软链接相关的机制，我们需要分成**两个阶段**来部署这些配置。

### 阶段一：在 U 盘系统 (Live ISO) 中进行基础安装
1. 将配置仓库克隆到本地：
```bash
git clone https://github.com/huzch/nix-dotfiles.git
cd nix-dotfiles
```
2. **停止并检查：** 确保你已经完成了上一节【注意事项】中的**所有配置修改**（尤其是注释掉 `flake.nix` 中的 home 引入）。
3. 确认无误后，执行一键安装脚本：
```bash
sudo ./init.sh
```
等待安装完成并重启你的电脑。

### 阶段二：进入新装好的 NixOS 系统中
重启并登录到你的新系统后，我们开始应用桌面环境和用户配置。

1. 准备配置和壁纸文件夹：
```bash
# 存放配置
mkdir -p ~/Documents && cd ~/Documents
git clone https://github.com/huzch/nix-dotfiles.git

# 存放壁纸
mkdir -p ~/Pictures && cd ~/Pictures
git clone https://github.com/huzch/wallpapers.git
```

2. 进入配置目录，并将你这台电脑专属的硬件配置文件覆盖过来：
```bash
cd ~/Documents/nix-dotfiles
cp /etc/nixos/hardware-configuration.nix ./nixos/
```

3. 将新文件添加到 Git 版本控制中：
> **注意：** Nix Flake 的机制要求文件必须被 Git 追踪（Add 或 Commit）后才能被读取到。
```bash
git add .
```

4. 启动魔法，应用整个系统的配置！
```bash
# 这里的 "space" 需替换为你之前在 flake.nix 中设置的配置名
sudo nixos-rebuild switch --flake ~/Documents/nix-dotfiles#space
```

### 💡 迷路了？查看快捷键帮助
应用系统配置并进入桌面后，你可以随时按下 **`Super (Windows 键) + /`** 召唤出快捷键帮助面板。里面列出了所有常用的基础操作快捷键（如打开终端、全屏、切换工作区等），以便随时查阅，帮助你快速上手新系统！

---

## 📁 目录结构说明 (Project Structure)
当你想要自己折腾和更改配置时，了解这个仓库的结构至关重要：
- **`flake.nix`**: 整个系统的总入口点。存放了系统的所有依赖记录以及主机的基本配置声明。
- **`nixos/`**: 存放**系统级**配置和底层设置。
  - `configuration.nix`: 系统核心组件、驱动、网络、字体等基础设置。
  - `hardware-configuration.nix`: 安装时生成的用于描述你电脑硬盘挂载和硬件内核模块的文件（每台电脑都不一样，必须用你自己的）。
  - `disko.nix`: 定义硬盘的自动分区规则。
- **`home/`**: 存放基于 `Home Manager` 的**用户级**环境配置（无需 root 即可作用于该用户）。
  - `app.nix` / `shell.nix` / `desktop.nix`: 管理你日常使用的软件、命令行环境以及桌面环境变量。
- **`dotfiles/`**: 核心的美化与应用配置文件（例如 Hyprland, Neovim, Waybar, Rofi 等的配置文件）。通过配置，这里的文件夹最终会被链接到你主目录的 `~/.config/` 下面。

---

## 🛠️ 如何维护你的配置 (Maintenance)
NixOS 最大的魅力在于“一切皆代码且可复现”。有了这个仓库，以后你想添加软件或修改桌面美化，只需记住在这个文件夹内操作：

### 1. 如何安装新软件？
- **系统底层组件**（如虚拟机、Docker、显卡核心驱动等）：打开并编辑 `nixos/configuration.nix`。
- **普通的日常独立软件**（如浏览器、聊天软件、播放器等）：打开并编辑 `home/app.nix` 等相关配置，在 `home.packages` 列表中添加。
> **小白提示:** 你可以在 [NixOS 搜索页 (search.nixos.org)](https://search.nixos.org/packages) 搜索你想安装软件的英文名，找到它的 Nix 包名后填进去。

### 2. 如何修改桌面外观或快捷键？
比如想修改 Hyprland 快捷键、改 Waybar 的样式颜色，或是配置 Neovim：**不要**去改 `~/.config/` 里的文件（那里是只读的软链接），而是直接在这个仓库的 `dotfiles/` 目录下找到它进行修改。

### 3. 如何应用你的修改？
**任何时候**，只要你修改了该仓库下的任意文件（或新增了文件），只需要打开终端执行：
```bash
cd ~/Documents/nix-dotfiles

# 第 1 步：通知 Git 你做了改动（极其重要，如果不 git add，Nix 会报找不到文件的错）
git add .

# 第 2 步：重新构建并切换系统（记得把 "space" 换成你 flake.nix 中的配置名）
sudo nixos-rebuild switch --flake .#space
```

> **系统升级提示:** NixOS 是滚动更新的。如果你想将系统的所有软件全部升到最新版，可以在仓库下运行 `nix flake update`，等它下载完最新的依赖锁后，再执行一次上面的 `nixos-rebuild switch` 即可。

---


## 🌟 为什么选择 NixOS？(Why NixOS?)
对于愿意折腾的玩家来说，NixOS 提供了无可比拟的系统掌控力：

### 1. 绝对的稳定性：版本锁定
Nix Flake 机制会生成一个 `flake.lock` 文件，里面精确记录了你当前系统中所有软件和底层库的 Hash 值。
这意味着，**只要你不主动运行 `nix flake update`去更新这个锁文件，你的系统环境就会被永久锁定在这个稳定的快照上**。无论你之后在这个库里怎么重装、怎么换电脑或者在什么时候部署，你安装的每一个软件的版本都会一模一样，杜绝了传统 Linux 中常见的“滚挂”现象。

### 2. 永不崩坏的系统：“世代”与回滚
每次你执行 `nixos-rebuild switch`，NixOS 都会创建一个新的“世代 (Generation)”。如果新装的软件导致系统崩溃，或者驱动更新后黑屏，你只需要在开机时的引导菜单 (GRUB/systemd-boot) 中选择上一个世代，系统就会**100% 恢复**到你上一次完全正常的状态。你再也不用害怕“把系统玩坏”了。

### 3. “一次配置，到处运行”
就像这个仓库展示的这样，你的整个操作系统——从底层的磁盘格式、显卡驱动，到上层的桌面主题、快捷键，再到你个人使用的全套软件，都可以用代码写死在这些 `.nix` 文件里。换新电脑时，再也不用花一整天时间去装环境、配主题、下软件，只需一行命令即可完美克隆你亲手打造的最熟悉的数字家园。

---

## 💖 喜欢的话求个 Star ⭐️
如果你觉得这份配置或者这篇小白指南对你的 NixOS 折腾之旅有所帮助，或者为你节省了配置环境的时间，**求求各位大佬/小可爱在右上角点个 Star ⭐️ 支持一下呀！**  
你的每一次点赞都是我持续维护和更新这个仓库的最大动力！在使用中如果有遇到什么问题或者有更好的建议，也非常欢迎提 Issue 或 PR 一起交流讨论~ 谢谢大家的支持！🎉
