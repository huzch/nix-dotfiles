## Overview
![Desktop Screenshot](https://private-user-images.githubusercontent.com/144591024/534302214-943ed2ff-b7fc-46f2-bec9-ce7b69561fa7.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjgxMDIwMTUsIm5iZiI6MTc2ODEwMTcxNSwicGF0aCI6Ii8xNDQ1OTEwMjQvNTM0MzAyMjE0LTk0M2VkMmZmLWI3ZmMtNDZmMi1iZWM5LWNlN2I2OTU2MWZhNy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwMTExJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDExMVQwMzIxNTVaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT00ZGFmYTdjNmZkYjc5OWZkNmI4NmVmMTVlODI4MGMwNDEwMzZlOTFjMzMzOWMyMzg4OTI3MzRhYzZhOGQ1NGQ4JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.ITZ1mjtVyWULevQn8mLys23ZwImvFNUXKZu9UCL5FQM)
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
