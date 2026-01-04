## Load up Live ISO
### Partition

```bash
sudo -i
lsblk
cfdisk /dev/vda

gpt labels

1G type: EFI
4G type: swap
remaining space, type: Linux Filesystem
```

### File System

```
mkfs.ext4 -L nixos /dev/vda3
mkswap -L swap /dev/vda2
mkfs.fat -F 32 -n boot /dev/vda1
```

### Mount

```bash
mount /dev/vda3 /mnt
mount --mkdir /dev/vda1 /mnt/boot
swapon /dev/vda2

lsblk
```

## Build up NixOS

### flake.nix && configuration.nix

```bash
nixos-generate-config --root /mnt
cd /mnt/etc/nixos/
rm configuration.nix ## because we have nix-dotfiles

git clone https://github.com/huzch/nix-dotfiles.git
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

sudo mv /etc/nixos/nix-dotfiles ~
cd nix-dotfiles
cp /etc/nixos/hardware-configuration.nix .
sudo git add . ## flake only see added or committed

sudo nixos-rebuild switch --flake ~/nix-dotfiles#space
```

