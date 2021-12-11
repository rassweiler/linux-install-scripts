#!/bin/bash

# ============================= Vars =============================
blue=$(tput setaf 4)
red=$(tput setaf 1)
green=$(tput setaf 2)
normal=$(tput sgr0)
printf "${red}Run this only after setting up script, otherwise ctrl+c, enter to continue...\n${normal}"
read -p ""

# ============================= Input =============================
printf "${blue}Enter Root Password:\n${normal}"
echo root:password | chpasswd
printf "${blue}Enter Hostname:\n${normal}"
read hostname
echo "Hostname: ${hostname}"


# ============================= Mirrors =============================
reflector -c Canada -c US -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy


# ============================= Timezone Locale =============================
ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime
hwclock --systohc
echo "en_CA.UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_CA.UTF-8" >> /etc/locale.conf


# ============================= Network =============================
echo ${hostname} >> /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       ${hostname}.localdomain ${hostname}" >> /etc/hosts


# ============================= Packages =============================
pacman -S grub efibootmgr snapper snap-pac grub-customizer os-prober
pacman -S networkmanager network-manager-applet dialog mtools dosfstools xdg-utils xdg-user-dirs alsa-utils inetutils base-devel openssh
#pacman -S tlp


# ============================= Mkinitcpio =============================
printf "${blue}Insert needed modules, enter to continue...\n${normal}"
read -p ""
nano /etc/mkinitcpio.conf
mkinitcpio -p linux-zen


# ============================= Grub =============================
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
printf "${blue}Insert intel_iommu=on in grub if needed, enter to continue...\n${normal}"
read -p ""
nano /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg


# ============================= Services =============================
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable reflector.timer
#systemctl enable tlp


# ============================= User =============================
printf "${blue}Enter Username:\n${normal}"
read username
echo "Username: ${username}"
useradd -mG wheel ${username}
echo ${username}:password | chpasswd
echo "${username} ALL=(ALL) ALL" >> /etc/sudoers.d/${username}

printf "${green}Setup completed, type exit, umount -a, and reboot\n${normal}"