## Overview
![Desktop Screenshot](./space.png)
<!-- To add screenshots: Create an issue, drag & drop your images, then copy the generated URL here -->

## Quick Start
> Dotfiles are built directly into the Nix configuration. The install script also prepares `~/Documents/nix-dotfiles` and `~/Pictures/wallpapers` in the new system.

### Live ISO
```bash
sudo -i
git clone https://github.com/huzch/nix-dotfiles.git
cd nix-dotfiles
./init.sh
```
WARN: before execute init.sh, please check these things on your own !!!
1. disko.nix : disk-type
2. flake.nix : cpu-platform + username + hostname
3. configuration.nix : hostname + cpu/gpu-setting
4. home/default.nix : username + userdirectory
5. init.sh : username + hostname

### 💡 Lost? Check the shortcuts help
After applying the system configuration and entering the desktop, you can press **`Alt + /`** at any time to summon the shortcuts help panel. It lists all the basic operation shortcuts (such as opening the terminal, full-screening, switching workspaces, etc.) to help you quickly get started with the new system!

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
