## Overview
![Desktop Screenshot](https://private-user-images.githubusercontent.com/144591024/532850531-2ebbcea9-4bdf-4668-8157-9c771e9dfb5a.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3Njc3OTM2OTAsIm5iZiI6MTc2Nzc5MzM5MCwicGF0aCI6Ii8xNDQ1OTEwMjQvNTMyODUwNTMxLTJlYmJjZWE5LTRiZGYtNDY2OC04MTU3LTljNzcxZTlkZmI1YS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwMTA3JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDEwN1QxMzQzMTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT05NTYzZDRhNTQzMTc0NjFlZjU1OTc0NDIwMDkxZTQyMThjZDhmNWRlMzBkYzlhM2ZlOWFmYjEzYTlhZDQzOTM3JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.PKFs_hc1RFN79fmzsYK-0gK1RhfSZuHH3IifKUJ7wkU)
<!-- To add screenshots: Create an issue, drag & drop your images, then copy the generated URL here -->

## Quick Start
> Due to soft-link problem, we need two step to set up nix-dotfiles.
### 1. Live ISO
```bash
git clone https://github.com/huzch/nix-dotfiles.git
cd nix-dotfiles
vim flake.nix ## comment users.huzch = import ./home;
sudo ./init.sh
```
NOTE: before execute init.sh, please check username, hostname, disk-type on your own !!!
### 2. NixOS
```bash
git clone https://github.com/huzch/wallpapers.git
git clone https://github.com/huzch/nix-dotfiles.git

cd nix-dotfiles
cp /etc/nixos/hardware-configuration.nix ./nixos
sudo git add . ## flake only see added or committed

sudo nixos-rebuild switch --flake ~/nix-dotfiles#space
```

## TODO
### Component
- [x] Wallpaper: swww
- [x] Status Bar: waybar
- [x] App Launcher: rofi
- [x] Clipboard Manager: cliphist
- [x] Lock Screen: hyprlock
- [x] Logout Menu: wlogout
- [x] Polkit: hyprpolkitagent
- [x] Idle Daemon: hypridle
- [x] Notification Daemon: swaync
### Animation
- [x] window
- [x] workspace
### Other
- [x] waybar icons(system)
- [x] fcitx5 rime + rime-ice + skin
### Hardware acceleration
To test dotfiles on virtual machine, i make only cpu and software settings (for some programs).

When running on real machine, please turn on gpu and hardware acceleration.