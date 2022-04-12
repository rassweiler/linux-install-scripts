#!/bin/bash

#     ,^vfFIIIIIIIIIIIIIIIIIIIIIIFfv/,        
#      ;z0WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW&n;     
#    ;SWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWK;   
#   1WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW[  
#  rWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWr 
# `BWMF11111*#WWWWWWWR11111111111111*vxC#MWWWWWWB`
# ;WWWWC,     <0WWWWWb                   `=BWWWWW;
# ;WWWWWMf`    `?NWWWb          ',,'       -BWWWW;
# ;WWWWWWWBv     .xMWb          RWWWWO`     nWWWW;
# ;WWWWWWWWW0=     ,CP          RWWWWW<     zWWWW;
# ;WWWWWWWWWWWK~     `          RWWWW&'    'BWWWW;
# ;WWWWWWWWWWWWWA               ;!!~-     /BWWWWW;
# ;WWWWWWWWWWWMy'                       ;KWWWWWWW;
# ;WWWWWWWWWWp:     `!          ^r=~      1MWWWWW;
# ;WWWWWWWWR~      *Bb          RWWWB^     ~MWWWW;
# ;WWWWWWB=      /RWWb          RWWWWM~     !MWWW;
# ;WWWWNv`     ;OWWWWb          RWWWWWN;     <WWW;
# ;WWMz`     -PWWWWWWb          RWWWWWWB:     JWW;
# `BMi111111FMWWWWWWWR1111111111BWWWWWWW&111111RB`
#  *WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW* 
#   vWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWx  
#    ~KWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWR~   
#      ~I&WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWBI~     
#         ,^vfFIIIIIIIIIIIIIIIIIIIIIIFfv/,     

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
printf "${green}Setting up file system (enter)\n${normal}"
read -p ""
wipefs /dev/${mainp}
mkfs.vfat ${bootp}
mkswap ${swapp}
swapon ${swapp}
mkfs.btrfs -f ${mainp}
mount ${mainp} /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var_log

printf "${green}Setting up file system Snapshots (enter)\n${normal}"
read -p ""
umount /mnt
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@ ${mainp} /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/log}
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@home ${mainp} /mnt/home
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@snapshots ${mainp} /mnt/.snapshots
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@var_log ${mainp} /mnt/var/log
mount ${bootp} /mnt/boot


# ============================= Location =============================
printf "${green}Setting up location system (enter)\n${normal}"
read -p ""
timedatectl set-ntp true
#reflector -c Canada -c US -a 6 --sort rate --download-timeout 60 --save /etc/pacman.d/mirrorlist
pacman -Syy

# ============================= Pacstrap =============================
printf "${green}Setting up pacstrap (enter)\n${normal}"
read -p ""
# Intel
#pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware nano intel-ucode cifs-utils reflector sudo git rsync
# Amd
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware nano amd-ucode cifs-utils reflector sudo git rsync
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt