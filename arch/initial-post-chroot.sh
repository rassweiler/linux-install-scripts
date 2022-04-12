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
printf "${red}Run this only after setting up script, otherwise ctrl+c, enter to continue...\n${normal}"
read -p ""

# ============================= Input =============================
printf "${blue}Enter Root Password:\n${normal}"
read rootp
echo "root:${rootp}" | chpasswd
printf "${blue}Enter Hostname:\n${normal}"
read hostname
echo "Hostname: ${hostname}"


# ============================= Mirrors =============================
printf "${green}Setting up mirrors\n${normal}"
reflector -c Canada -c US -a 6 --sort rate --download-timeout 60 --save /etc/pacman.d/mirrorlist
pacman -Syy


# ============================= Timezone Locale =============================
printf "${green}Setting up system locale\n${normal}"
ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime
hwclock --systohc
echo "en_CA.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_CA.UTF-8" >> /etc/locale.conf


# ============================= Network =============================
printf "${green}Setting up system network\n${normal}"
echo ${hostname} >> /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       ${hostname}.localdomain ${hostname}" >> /etc/hosts


# ============================= Packages =============================
printf "${green}Setting up system packages\n${normal}"
pacman -S grub efibootmgr snapper snap-pac grub-customizer os-prober
pacman -S networkmanager network-manager-applet dialog mtools dosfstools xdg-utils xdg-user-dirs alsa-utils inetutils base-devel openssh
#pacman -S tlp


# ============================= Mkinitcpio =============================
printf "${green}Setting up system mkinitcpio\n${normal}"
printf "${blue}Insert needed modules, enter to continue...\n${normal}"
read -p ""
nano /etc/mkinitcpio.conf
mkinitcpio -p linux-zen


# ============================= Grub =============================
printf "${green}Setting up system grub\n${normal}"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
printf "${blue}Insert intel_iommu=on in grub if needed, enter to continue...\n${normal}"
read -p ""
nano /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg


# ============================= Services =============================
printf "${green}Setting up system services\n${normal}"
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable reflector.timer
#systemctl enable tlp


# ============================= User =============================
printf "${green}Setting up system user\n${normal}"
printf "${blue}Enter Username:\n${normal}"
read username
echo "Username: ${username}"
useradd -mG wheel ${username}
printf "${blue}Enter User Password:\n${normal}"
read userp
echo "${username}:${userp}" | chpasswd
echo "${username} ALL=(ALL) ALL" >> /etc/sudoers.d/${username}

printf "${green}Setup completed, type exit, umount -a, and reboot\n${normal}"