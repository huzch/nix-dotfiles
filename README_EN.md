## Overview
![Desktop Screenshot](./space.png)
<!-- To add screenshots: Create an issue, drag & drop your images, then copy the generated URL here -->

> This is a personal NixOS + Hyprland desktop configuration. This README focuses on the items you should verify before installation and the basic workflow for maintaining the system afterward.

---

## Background
My Linux path started with Ubuntu, moved through Arch, and eventually landed on NixOS. Ubuntu was convenient, Arch was flexible, and NixOS felt like a practical balance between control and stability: the system is still highly configurable, but the configuration is declarative and every rebuild creates a rollback point. People sometimes describe NixOS as what you might get if Ubuntu and Arch had a child. It is not a precise definition, but it captures why I ended up here.

I used to run Windows and Linux as a single-disk dual-boot setup. In practice, that setup was easy to disturb through Windows updates, bootloader changes, or simple mistakes. My current setup is more conservative: Windows has one physical disk, Linux has another, and the two systems stay mostly independent. I also tried running Linux full-time on laptops, but battery life, sleep behavior, and mobile usability still felt better on macOS for my use case. Today I use macOS on laptops and Windows + Linux on a desktop.

This repository is therefore not trying to be a universal installer for every machine. It is designed around a narrower setup: a desktop PC, a dedicated Linux disk, repeatable installation, and rollback-friendly maintenance. If your setup is close to that, this configuration should be easier to reason about. If you plan to use it on a single-disk dual-boot machine or a laptop, check the disk, bootloader, and hardware assumptions carefully first.

---

## ⚠️ Check These Five Items Before Installing
This configuration can partition disks, install NixOS, and apply user-level dotfiles automatically. That is convenient, but a wrong value can have a direct impact. Review the items below in order before running the install script.

```bash
USER_NAME=xxx
HOST_NAME=xxx
DISK=/dev/nvme0n1
GPU=nvidia
CPU=amd
```

| Priority | Item | Risk | What to verify |
| --- | --- | --- | --- |
| P0 | `DISK` | Selects the disk that will be repartitioned and formatted. A wrong value can erase the wrong drive. | Run `lsblk` in the Live ISO and make sure the target is not the USB installer, an external drive, or a disk with data you still need. |
| P1 | `USER_NAME` | Affects the system user, Home Manager, autologin, password setup, and the home directory. A wrong value can cause login or path issues after installation. | Use the Linux username you plan to keep. Lowercase letters, digits, `-`, and `_` are the safest choices. |
| P1 | `GPU` | Affects graphics drivers and desktop startup. A mismatch can lead to a black screen, failed desktop startup, or broken hardware acceleration. | The default configuration targets an Nvidia dGPU. AMD and Intel graphics users should adjust the graphics-related options in `nixos/configuration.nix`. |
| P2 | `CPU` | Mostly affects microcode and minor hardware-specific settings. It is usually less severe than disk or GPU mistakes, but still worth setting correctly. | Keep `hardware.cpu.amd.updateMicrocode` for AMD. Intel users should switch to the Intel microcode option. |
| P2 | `HOST_NAME` | Affects the flake configuration name, system hostname, and future rebuild commands. Mistakes are usually fixable, but they add avoidable troubleshooting. | Keep the name consistent across `flake.nix`, `nixos/configuration.nix`, `init.sh`, and rebuild commands. |

### Where To Change Them
- `DISK`: edit `device` in `nixos/disko.nix`.
- `USER_NAME`: replace `huzch` in `flake.nix`, `home/default.nix`, `nixos/configuration.nix`, and `init.sh`.
- `HOST_NAME`: replace `space` in `flake.nix`, `nixos/configuration.nix`, `init.sh`, and rebuild commands.
- `GPU`: adjust the Nvidia / AMD / Intel graphics settings in `nixos/configuration.nix`.
- `CPU`: adjust the CPU microcode option in `nixos/configuration.nix`.

If you are unsure about any of these values, stop and verify first. NixOS generations are good at rollback, but they cannot restore a disk that was formatted by mistake.

### Network And Proxy Notes
Depending on your region and network, installing NixOS and fetching GitHub / Nix cache resources may require a working proxy.

- **Stage 1: Live ISO environment**
  If the machine does not have a proxy client yet, one practical option is USB tethering from a phone with a proxy app that allows LAN connections. Then set the proxy address in `init.sh` to the phone gateway IP and proxy port:
  ```bash
  export http_proxy="http://192.168.42.129:7890"
  export https_proxy="http://192.168.42.129:7890"
  ```

- **Stage 2: Installed NixOS system**
  After rebooting into the installed system, point the system proxy to your local proxy client if needed:
  ```nix
  networking.proxy.default = "http://127.0.0.1:7890";
  ```

---

## Quick Start
> Dotfiles are built directly into the Nix configuration. The install script also prepares `~/Documents/nix-dotfiles` and `~/Pictures/wallpapers` in the installed system.

### Install From A Live ISO
1. Clone this repository:
```bash
sudo -i
git clone https://github.com/huzch/nix-dotfiles.git
cd nix-dotfiles
```

2. Stop and check that the five items above are correct, especially `DISK`, `USER_NAME`, `HOST_NAME`, `GPU`, `CPU`, and any proxy settings you need.

3. Run the installer:
```bash
./init.sh
```

After installation finishes, reboot. The script prepares `~/Documents/nix-dotfiles` and `~/Pictures/wallpapers` in the new system, so you do not need to clone them again manually.

### Shortcut Help
After applying the system configuration and entering the desktop, press **`Alt + /`** to open the shortcuts help panel.

---

## Project Structure
- **`flake.nix`**: Main entry point for the system configuration.
- **`nixos/`**: System-level configuration.
  - `configuration.nix`: Core system settings, drivers, networking, fonts, and services.
  - `hardware-configuration.nix`: Hardware and filesystem configuration generated during installation. This is machine-specific.
  - `disko.nix`: Disk partitioning layout.
- **`home/`**: Home Manager user-level configuration.
  - `app.nix` / `shell.nix` / `desktop.nix`: Applications, shell settings, and desktop environment settings.
- **`dotfiles/`**: Application and desktop dotfiles, such as Hyprland, Neovim, Waybar, Rofi, and related configs.

---

## Maintenance
After installation, use the repository under `~/Documents/nix-dotfiles` as the source of truth.

### Install New Packages
- For system-level components, edit `nixos/configuration.nix`.
- For regular user applications, edit the relevant file under `home/`, usually `home/app.nix`.

You can search for package names on [search.nixos.org](https://search.nixos.org/packages).

### Change Desktop Or App Config
Do not edit files directly under `~/.config` as your source of truth. Edit the matching files under this repository's `dotfiles/` directory instead.

### Apply Changes
```bash
cd ~/Documents/nix-dotfiles

# Make sure new files are visible to the flake.
git add .

# Replace "space" with your flake configuration name if you changed it.
sudo nixos-rebuild switch --flake .#space
```

To update locked package versions, run:
```bash
nix flake update
sudo nixos-rebuild switch --flake .#space
```

---

## Why NixOS?

### Reproducible Versions
The `flake.lock` file records exact dependency revisions. As long as you do not update the lock file, reinstalling from the same repository gives you the same package set.

### Generations And Rollback
Each `nixos-rebuild switch` creates a new system generation. If a new generation breaks something, you can boot into an older generation from the boot menu.

### One Configuration, Repeatable Setup
The system configuration, user environment, desktop setup, and application dotfiles live in one repository. This makes it easier to reinstall, migrate, and audit changes over time.

---

## Feedback
If this configuration is useful to you, a Star makes it easier to follow future updates. Issues and pull requests are welcome.
