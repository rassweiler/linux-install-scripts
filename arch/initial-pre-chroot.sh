#!/bin/bash

# ============================= Vars =============================
blue=$(tput setaf 4)
red=$(tput setaf 1)
green=$(tput setaf 2)
normal=$(tput sgr0)


# ============================= Input =============================
printf "${red}Run this only after setting up gdisk, otherwise ctrl+c...\n${normal}"
printf "${blue}Enter boot partition:\n${normal}"
read bootp
echo "Boot: ${bootp}"
printf "${blue}Enter swap partition:\n${normal}"
read swapp
echo "Swap: ${swapp}"
printf "${blue}Enter main partition:\n${normal}"
read mainp
echo "Main: ${mainp}"


# ============================= FS =============================
printf "${green}Setting up file system\n${normal}"
read -p ""
mkfs.vfat ${bootp}
mkswap ${swapp}
swapon ${swapp}
mkfs.btrfs ${mainp}
mount ${mainp} /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var_log
umount /mnt
mount -o noatime,compress=lzo,space_cache=v2,subvol=@ ${mainp} /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/log}
mount -o noatime,compress=lzo,space_cache=v2,subvol=@home ${mainp} /mnt/home
mount -o noatime,compress=lzo,space_cache=v2,subvol=@snapshots ${mainp} /mnt/.snapshots
mount -o noatime,compress=lzo,space_cache=v2,subvol=@var_log ${mainp} /mnt/var/log
mount ${bootp} /mnt/boot


# ============================= Location =============================
printf "${green}Setting up location system\n${normal}"
read -p ""
timedatectl set-ntp true
reflector -c Canada -c US -a 6 --sort rate --download-timeout 60 --save /etc/pacman.d/mirrorlist
pacman -Syy

# ============================= Pacstrap =============================
printf "${green}Setting up pacstrap\n${normal}"
read -p ""
# Intel
#pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware nano intel-ucode cifs-utils reflector sudo git rsync
# Amd
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware nano amd-ucode cifs-utils reflector sudo git rsync
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt