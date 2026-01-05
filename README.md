```bash
git clone https://github.com/huzch/nix-dotfiles.git
cd nix-dotfiles
sudo ./init.sh
```

```bash
git clone https://github.com/huzch/wallpapers.git
git clone https://github.com/huzch/nix-dotfiles.git

cd nix-dotfiles
vim flake.nix ## uncomment users.huzch = import ./home.nix;
cp /etc/nixos/hardware-configuration.nix .
sudo git add . ## flake only see added or committed

sudo nixos-rebuild switch --flake ~/nix-dotfiles#space
```