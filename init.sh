#!/bin/sh

set -e # 遇到错误立即停止

USER_NAME="$(sed -n 's/.*userName = "\(.*\)";.*/\1/p' nixos/host.nix)"
HOST_NAME="$(sed -n 's/.*hostName = "\(.*\)";.*/\1/p' nixos/host.nix)"
DISK="$(sed -n 's/.*disk = "\(.*\)";.*/\1/p' nixos/host.nix)"
CPU="$(sed -n 's/.*cpu = "\(.*\)";.*/\1/p' nixos/host.nix)"
GPU="$(sed -n 's/.*gpu = "\(.*\)";.*/\1/p' nixos/host.nix)"
USER_HOME="/mnt/home/${USER_NAME}"
USER_DOCS="${USER_HOME}/Documents"
USER_PICTURES="${USER_HOME}/Pictures"
DOTFILES_TARGET="${USER_DOCS}/nix-dotfiles"
WALLPAPERS_TARGET="${USER_PICTURES}/wallpapers"
STATE_DIR="/mnt/var/lib/nix-dotfiles-install-state"
RESET_STATE=0

if [ "$#" -gt 1 ] || { [ "$#" -eq 1 ] && [ "$1" != "--reset" ]; }; then
  echo "Usage: $0 [--reset]"
  exit 1
fi

if [ "${1:-}" = "--reset" ]; then
  RESET_STATE=1
fi

# 检查是否为 root
if [ "$(id -u)" -ne 0 ]; then
  echo "please run in root (sudo $0)"
  exit 1
fi

step_done() {
  [ -f "${STATE_DIR}/$1.done" ]
}

mark_done() {
  mkdir -p "${STATE_DIR}"
  touch "${STATE_DIR}/$1.done"
}

run_once() {
  step="$1"
  desc="$2"
  shift 2

  if step_done "${step}"; then
    echo "==> ${desc}: skipped"
    return 0
  fi

  echo "==> ${desc}"
  "$@"
  mark_done "${step}"
}

run_always() {
  desc="$1"
  shift

  echo "==> ${desc}"
  "$@"
}

validate_config() {
  if [ -z "${USER_NAME}" ] || [ -z "${HOST_NAME}" ] || [ -z "${DISK}" ] || [ -z "${CPU}" ] || [ -z "${GPU}" ]; then
    echo "failed to read userName, hostName, disk, cpu, or gpu from nixos/host.nix"
    exit 1
  fi

  if [ "${RESET_STATE}" -eq 1 ]; then
    rm -rf "${STATE_DIR}"
  fi

  if [ ! -b "${DISK}" ]; then
    echo "target disk does not exist or is not a block device: ${DISK}"
    echo
    lsblk
    exit 1
  fi
}

confirm_disko() {
  echo "==> Install summary"
  echo "    User: ${USER_NAME}"
  echo "    Host: ${HOST_NAME}"
  echo "    Disk: ${DISK}"
  echo "    CPU : ${CPU}"
  echo "    GPU : ${GPU}"
  echo
  echo "==> Current block devices"
  lsblk
  echo
  echo "WARNING: this will repartition and format ${DISK}."
  echo "All data on ${DISK} will be erased."
  printf 'Type exactly "ERASE %s" to continue: ' "${DISK}"
  read -r CONFIRM
  if [ "${CONFIRM}" != "ERASE ${DISK}" ]; then
    echo "confirmation mismatch, aborting."
    exit 1
  fi
}

run_disko() {
  desc="1. Running Disko for partitioning and mounting..."

  if step_done "01-disko"; then
    echo "==> ${desc}: skipped"
    return 0
  fi

  confirm_disko
  echo "==> ${desc}"
  nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./nixos/disko.nix
  mark_done "01-disko"
}

generate_hardware_config() {
  nixos-generate-config --no-filesystems --root /mnt
}

copy_config() {
  cp /mnt/etc/nixos/hardware-configuration.nix ./nixos/
  cp -r flake.* ./nixos/ ./home/ ./dotfiles/ /mnt/etc/nixos/
}

install_nixos() {
  nixos-install --flake "/mnt/etc/nixos#${HOST_NAME}"
}

set_user_password() {
  nixos-enter --root /mnt -c "passwd ${USER_NAME}"
}

prepare_user_files() {
  mkdir -p "${USER_DOCS}" "${USER_PICTURES}"
  rm -rf "${DOTFILES_TARGET}"
  cp -a . "${DOTFILES_TARGET}"

  if [ ! -d "${WALLPAPERS_TARGET}/.git" ]; then
    rm -rf "${WALLPAPERS_TARGET}"
    git clone https://github.com/huzch/wallpapers.git "${WALLPAPERS_TARGET}"
  fi

  nixos-enter --root /mnt -c "chown -R ${USER_NAME}:users /home/${USER_NAME}/Documents /home/${USER_NAME}/Pictures"
}

validate_config
run_disko
run_once "02-hardware" "2. Generating hardware configuration..." generate_hardware_config
run_always "3. Preparing configuration files..." copy_config
run_once "04-nixos-install" "4. Installing NixOS..." install_nixos
run_once "05-user-files" "5. Preparing user files..." prepare_user_files
run_always "6. Setting user password..." set_user_password
echo "==> Installation complete! Please remove the installation media and reboot."
