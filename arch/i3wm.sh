#!/bin/bash
blue=$(tput setaf 4)
red=$(tput setaf 1)
green=$(tput setaf 2)
normal=$(tput sgr0)

# ============================= Base =============================
./xorg.sh


# ============================= GUI Packages =============================
printf "${green}Installing i3wm gui packages... (enter)\n${normal}"
read -p ""
sudo pacman -S thunar gvfs feh conky dmenu picom rofi volumeicon


# ============================= i3wm =============================
printf "${green}Installing i3wm... (enter)\n${normal}"
read -p ""
sudo pacman -S i3-gaps i3blocks i3status


# ============================= Audio =============================
printf "${green}Installing pavucontrol... (enter)\n${normal}"
read -p ""
sudo pacman -S pavucontrol


# ============================= Configs =============================
printf "${green}Installing i3wm configs... (enter)\n${normal}"
read -p ""
cd ~
git clone https://github.com/rassweiler/dotfiles.git
cd dotfiles
./install
cd ~


# ============================= Complete =============================
sudo pacman -Syu
printf "${green}Completed Install, press enter to reboot...\n${normal}"
read -p ""
sudo reboot now