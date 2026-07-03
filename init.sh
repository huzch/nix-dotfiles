#!/bin/sh

set -e # 遇到错误立即停止

USER_NAME="$(sed -n 's/.*userName = "\(.*\)";.*/\1/p' nixos/host.nix)"
HOST_NAME="$(sed -n 's/.*hostName = "\(.*\)";.*/\1/p' nixos/host.nix)"
USER_HOME="/mnt/home/${USER_NAME}"
USER_DOCS="${USER_HOME}/Documents"
USER_PICTURES="${USER_HOME}/Pictures"
DOTFILES_TARGET="${USER_DOCS}/nix-dotfiles"
WALLPAPERS_TARGET="${USER_PICTURES}/wallpapers"

# 检查是否为 root
if [ "$(id -u)" -ne 0 ]; then
  echo "please run in root (sudo $0)"
  exit 1
fi

# export https_proxy="http://192.168.24.124:7890"

echo "==> 1. Running Disko for partitioning and mounting..."
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./nixos/disko.nix
echo "==> 2. Generating hardware configuration..."
nixos-generate-config --no-filesystems --root /mnt
echo "==> 3. Preparing configuration files..."
cp /mnt/etc/nixos/hardware-configuration.nix ./nixos/
cp -r flake.* ./nixos/ ./home/ ./dotfiles/ /mnt/etc/nixos/
echo "==> 4. Installing NixOS..."
nixos-install --flake "/mnt/etc/nixos#${HOST_NAME}"
echo "==> 5. Preparing user files..."
mkdir -p "${USER_DOCS}" "${USER_PICTURES}"
cp -a . "${DOTFILES_TARGET}"
git clone https://github.com/huzch/wallpapers.git "${WALLPAPERS_TARGET}"
nixos-enter --root /mnt -c "chown -R ${USER_NAME}:users /home/${USER_NAME}/Documents /home/${USER_NAME}/Pictures"
echo "==> 6. Setting user password..."
nixos-enter --root /mnt -c "passwd ${USER_NAME}"
echo "==> Installation complete! Please remove the installation media and reboot."
