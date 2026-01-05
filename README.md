## Quick Start
> Due to soft-link problem, we need two step to set up nix-dotfiles.

### 1. Live ISO
```bash
git clone https://github.com/huzch/nix-dotfiles.git
cd nix-dotfiles
vim flake.nix ## comment users.huzch = import ./home.nix;
sudo ./init.sh
```
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
- [ ] Wallpaper: swww
- [ ] Status Bar: waybar
- [ ] App Launcher: rofi
- [ ] Clipboard Manager
- [ ] Lock Screen: hyprlock
- [ ] Logout Menu: wlogout
- [ ] Polkit
- [ ] Idle Daemon: hypridle
- [ ] Notification Daemon: swaync
