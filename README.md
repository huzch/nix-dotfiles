## Load up Live ISO
```bash
git clone https://github.com/huzch/nix-dotfiles.git

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disko.nix
```

## Build up NixOS

### flake.nix && configuration.nix

```bash
nixos-generate-config --no-filesystems --root /mnt
cd /mnt/etc/nixos/
rm configuration.nix ## because we have nix-dotfiles

cp nix-dotfiles/*.nix .
rm home.nix ## due to soft-link problem, we need two-prase build
vim flake.nix ## comment users.huzch = import ./home.nix;

nixos-install --flake /mnt/etc/nixos#space
nixos-enter --root /mnt -c 'passwd huzch'
reboot
```

### home.nix

```bash
git clone https://github.com/huzch/wallpapers.git
git clone https://github.com/huzch/nix-dotfiles.git

cd nix-dotfiles
cp /etc/nixos/hardware-configuration.nix .
sudo git add . ## flake only see added or committed

sudo nixos-rebuild switch --flake ~/nix-dotfiles#space
```

