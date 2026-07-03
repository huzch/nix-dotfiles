## 概览 (Overview)
![Desktop Screenshot](./space.png)
<!-- 如果想添加截图：可以创建一个 issue，将图片拖拽进去，然后将生成的链接复制到这里 -->

> 这是一份基于 NixOS + Hyprland 的个人桌面配置。README 会尽量用直接的步骤说明安装前需要确认的内容，以及后续如何维护。

---

## 背景
我接触 Linux 是从 Ubuntu 开始的，后来用过 Arch，最后转到 NixOS。Ubuntu 省心，Arch 自由，NixOS 给我的感觉更接近两者之间的平衡：既能精确控制系统，又能通过声明式配置和世代回滚保留稳定性。有人说“如果 Ubuntu 和 Arch 有一个孩子，那就是 NixOS”，这个说法不严谨，但很贴近我选择它的原因。

我以前也装过 Windows + Linux 的单盘双系统，但单盘双系统容易被 Windows 更新、引导项变动或误操作影响。现在我的选择更保守：Windows 和 Linux 分别放在两块硬盘上，互不干扰。笔记本上我也尝试过长期使用 Linux，但续航、睡眠和移动场景的综合体验始终不如 Mac，所以目前是笔记本用 macOS，台式机用 Windows + Linux 双盘。

因此，这个仓库的设计目标不是做一个适配所有设备的通用发行版，而是为“台式机 + 独立 Linux 磁盘 + 可重复安装 + 可回滚维护”这个场景服务。如果你的使用方式接近这个前提，它会更省心；如果你准备在单盘双系统或笔记本上使用，请先确认磁盘、引导和硬件适配风险。

---

## ⚠️ 安装前请先确认这五项
这份配置可以自动分区、安装系统并写入用户配置。它省事，但也意味着有些选项一旦填错，影响会比较直接。建议先按下面的顺序确认，不要急着运行脚本。

```bash
USER_NAME=xxx
HOST_NAME=xxx
DISK=/dev/nvme0n1
GPU=nvidia
CPU=amd
```

| 优先级 | 配置项 | 风险 | 需要确认的事 |
| --- | --- | --- | --- |
| P0 | `DISK` | 会决定哪块磁盘被重新分区和格式化，填错会清空错误磁盘。 | 在 Live ISO 中运行 `lsblk`，确认目标盘不是 U 盘、移动硬盘或存有重要数据的硬盘。 |
| P1 | `USER_NAME` | 影响系统用户、Home Manager、自动登录、密码设置和用户目录。填错通常会导致安装后登录或路径异常。 | 使用你准备长期使用的 Linux 用户名，建议只用小写字母、数字、`-` 或 `_`。 |
| P1 | `GPU` | 影响图形驱动和桌面启动。显卡配置不匹配时，常见结果是黑屏、无法进入桌面或硬件加速异常。 | 当前默认偏向 Nvidia 独显；AMD/Intel 核显用户先修改 `nixos/host.nix` 中的 `gpu`。 |
| P2 | `CPU` | 主要影响微码和少量硬件适配。填错通常不如磁盘和显卡严重，但不建议忽略。 | 当前默认是 `amd`；Intel 用户修改 `nixos/host.nix` 中的 `cpu`。 |
| P2 | `HOST_NAME` | 影响 flake 配置名、系统主机名和后续 rebuild 命令。填错一般可修，但会增加排错成本。 | 在 `nixos/host.nix` 中设置后，相关 NixOS 和 Home Manager 配置会自动引用它。 |

### 对应修改位置
- `DISK`: 修改 `nixos/disko.nix` 中的 `device`。
- `USER_NAME`: 修改 `nixos/host.nix` 中的 `userName`。
- `HOST_NAME`: 修改 `nixos/host.nix` 中的 `hostName`。
- `GPU`: 修改 `nixos/host.nix` 中的 `gpu`，可选值建议保持为 `nvidia`、`amd` 或 `intel`。
- `CPU`: 修改 `nixos/host.nix` 中的 `cpu`，可选值建议保持为 `amd` 或 `intel`。

如果你不确定某一项，先停在这里确认。NixOS 的回滚能力很强，但它不能恢复被格式化的错误磁盘。

### 网络与代理配置 (Proxy Settings)
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
> 当前配置会在安装时直接把 dotfiles 纳入 Nix 构建，不依赖用户目录中的软链接。安装脚本也会把配置仓库和壁纸仓库提前放到新系统用户目录中。

### 在 U 盘系统 (Live ISO) 中安装
1. 将配置仓库克隆到本地：
```bash
sudo -i
git clone https://github.com/huzch/nix-dotfiles.git
cd nix-dotfiles
```
2. **停止并检查：** 确保你已经完成了上一节“五项确认”中的配置修改，尤其是用户名、主机名、磁盘、CPU/GPU 和代理设置。
3. 确认无误后，执行一键安装脚本：
```bash
./init.sh
```
等待安装完成并重启你的电脑。脚本会在新系统中准备好 `~/Documents/nix-dotfiles` 和 `~/Pictures/wallpapers`，首次启动后无需再手动 clone。

### 💡 快捷键帮助
应用系统配置并进入桌面后，你可以随时按下 **`Alt + /`** 召唤出快捷键帮助面板。里面列出了所有常用的基础操作快捷键（如打开终端、全屏、切换工作区等），以便随时查阅，帮助你快速上手新系统！

---

## 📁 目录结构说明 (Project Structure)
当你想要自己折腾和更改配置时，了解这个仓库的结构至关重要：
- **`flake.nix`**: 整个系统的总入口点。存放了系统的所有依赖记录以及主机的基本配置声明。
- **`nixos/`**: 存放**系统级**配置和底层设置。
  - `configuration.nix`: 系统核心组件、驱动、网络、字体等基础设置。
  - `host.nix`: 当前机器的用户名、主机名、CPU 和 GPU 类型。
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
比如想修改 Hyprland 快捷键、改 Waybar 的样式颜色，或是配置 Neovim：**不要**去改 `~/.config/` 里的文件（那里由 Home Manager 管理），而是直接在这个仓库的 `dotfiles/` 目录下找到它进行修改。

### 3. 如何应用你的修改？
**任何时候**，只要你修改了该仓库下的任意文件（或新增了文件），只需要打开终端执行：
```bash
cd ~/Documents/nix-dotfiles

# 第 1 步：通知 Git 你做了改动（极其重要，如果不 git add，Nix 会报找不到文件的错）
git add .

# 第 2 步：重新构建并切换系统（把 "space" 换成 nixos/host.nix 中的 hostName）
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

## 反馈
如果这份配置对你有帮助，可以点一个 Star 方便后续关注。遇到问题或有改进建议，也欢迎通过 Issue 或 PR 交流。
