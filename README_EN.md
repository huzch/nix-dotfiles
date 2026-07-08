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

## ⚠️ Before You Install
The install script partitions and formats the target disk before installing NixOS. NixOS generations are good at rollback, but they cannot restore a disk that was formatted by mistake. Before running the script, verify the target disk with `lsblk`.

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
> Dotfiles are linked from `dotfiles/` into `~/.config/` by Home Manager. This keeps application configs independent and hot-editable: changes made in the repository can be picked up by the target program without rebuilding the whole system. The install script also prepares `~/Documents/nix-dotfiles` and `~/Pictures/wallpapers` in the installed system.
>
> The installer uses a two-stage flow automatically: it first installs a base system without Home Manager, then copies this repository into the new user's home directory, and finally activates the full configuration inside the installed system. You do not need to edit `flake.nix` or temporarily comment out Home Manager by hand.

### Install From A Live ISO
1. Clone this repository:
```bash
sudo -i
git clone https://github.com/huzch/nix-dotfiles.git
cd nix-dotfiles
```

2. Run the installer and follow the prompts for username, email, hostname, disk, CPU/GPU, and any proxy settings. It prints an install summary and `lsblk` output, then requires `ERASE <disk>` before formatting the disk:
```bash
./init.sh
```

Internally, the script installs `#<hostName>-install` first, prepares `~/Documents/nix-dotfiles` under `/mnt`, and then switches to the full `#<hostName>` configuration. This avoids evaluating Home Manager before the out-of-store dotfile link target exists at `~/Documents/nix-dotfiles/dotfiles`.

The script asks for these values and writes them back to `nixos/host.nix`. Square brackets `[]` show the current value; press Enter to keep it. Parentheses `()` show valid choices.
```bash
User name [huzch]:
User email [huzch123@gmail.com]:
Host name [space]:
Target disk [/dev/nvme0n1]:
CPU (amd/intel) [amd]:
GPU (nvidia/amd/intel/none) [nvidia]:
```

| Priority | Item | What to verify |
| --- | --- | --- |
| P0 | `DISK` | This is the only option that directly affects data safety. Make sure the target is not the USB installer, an external drive, or a disk with data you still need. |
| P1 | `GPU` / `USER_NAME` | GPU selection affects whether the desktop starts correctly. The username affects login and the home directory. |
| P2 | `CPU` / `HOST_NAME` | CPU mainly affects microcode. Hostname affects the flake name and future rebuild commands. |

After installation finishes, reboot. The script prepares `~/Documents/nix-dotfiles` and `~/Pictures/wallpapers` in the new system and already applies the full system configuration, so you do not need to clone or rebuild manually on first boot.

The install script supports checkpoint-based retries. After a key step succeeds, it writes state under `/mnt/var/lib/nix-dotfiles-install-state`; if the script fails later because of network or another issue, running `./init.sh` again skips completed steps. To clear checkpoint state and retry from scratch:
```bash
./init.sh --reset
```

### Shortcut Help
After applying the system configuration and entering the desktop, press **`Alt + /`** to open the shortcuts help panel.

---

## Project Structure
- **`flake.nix`**: Main entry point for the system configuration.
- **`nixos/`**: System-level configuration.
  - `configuration.nix`: Core system settings, drivers, networking, fonts, and services.
  - `host.nix`: Current machine settings for username, email, hostname, disk, CPU, and GPU type.
  - `hardware-configuration.nix`: Hardware and filesystem configuration generated during installation. This is machine-specific.
  - `disko.nix`: Disk partitioning layout.
- **`home/`**: Home Manager user-level configuration.
  - `app.nix` / `shell.nix` / `desktop.nix`: Applications, shell settings, and desktop environment settings.
- **`dotfiles/`**: Application and desktop dotfiles, such as Hyprland, Neovim, Waybar, Rofi, and related configs. Home Manager links these directories into `~/.config/` with out-of-store symlinks, which keeps them easy to edit and debug independently.

---

## Maintenance
After installation, use the repository under `~/Documents/nix-dotfiles` as the source of truth.

### Install New Packages
- For system-level components, edit `nixos/configuration.nix`.
- For regular user applications, edit the relevant file under `home/`, usually `home/app.nix`.

You can search for package names on [search.nixos.org](https://search.nixos.org/packages).

### Change Desktop Or App Config
Edit the matching files under this repository's `dotfiles/` directory. The related paths under `~/.config` are links back to this repository, so many application-level changes can be picked up by reloading or reopening the target program.

### Apply Changes
If you only changed existing files under `dotfiles/`, you usually do not need to run `nixos-rebuild`.

Run a rebuild when you change `.nix` files, update packages, adjust services, or add files that should be tracked by the Nix configuration:
```bash
cd ~/Documents/nix-dotfiles

# Make sure new or renamed Nix-managed files are visible to the flake.
git add .

# Replace "space" with hostName from nixos/host.nix if you changed it.
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
