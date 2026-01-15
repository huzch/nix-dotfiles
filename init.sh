#!/bin/sh

set -e # 遇到错误立即停止

# 检查是否为 root
if [ "$EUID" -ne 0 ]; then
  echo "please run in root (sudo $0)"
  exit 1
fi

# export https_proxy="http://192.168.24.124:7890"

echo "==> 1. Running Disko for partitioning and mounting..."
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./nixos/disko.nix
echo "==> 2. Generating hardware configuration..."
nixos-generate-config --no-filesystems --root /mnt
echo "==> 3. Preparing configuration files..."
rm /mnt/etc/nixos/configuration.nix
mv /mnt/etc/nixos/* ./nixos/
cp -r flake.* ./nixos/ /mnt/etc/nixos/
echo "==> 4. Installing NixOS..."
nixos-install --flake /mnt/etc/nixos#space
echo "==> 5. Setting user password..."
nixos-enter --root /mnt -c 'passwd huzch'
echo "==> Installation complete! Please remove the installation media and reboot."
