## Quick Start
> Due to soft-link problem, we need two step to set up nix-dotfiles.

### 1. Live ISO
```bash
git clone https://github.com/huzch/nix-dotfiles.git
cd nix-dotfiles
vim flake.nix ## comment users.huzch = import ./home.nix;
sudo ./init.sh
```
NOTE: before execute init.sh, please check username, hostname, disk-type on your own !!!
### 2. NixOS
```bash
git clone https://github.com/huzch/wallpapers.git
git clone https://github.com/huzch/nix-dotfiles.git

cd nix-dotfiles
cp /etc/nixos/hardware-configuration.nix .
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
- [ ] window
- [ ] workspace
### Other
- [ ] waybar icons(system/notification)
- [ ] fcitx5 skin or rime conf
### Hardware acceleration
To test dotfiles on virtual machine, i make only cpu and software settings (for some programs).

When running on real machine, please turn on gpu and hardware acceleration.