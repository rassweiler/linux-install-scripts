#!/bin/bash
blue=$(tput setaf 4)
red=$(tput setaf 1)
green=$(tput setaf 2)
normal=$(tput sgr0)

# ============================= Base =============================
./xorg-intel.sh
#./xorg-amd.sh


# ============================= GUI Packages =============================
printf "${green}Installing i3wm gui packages...\n${normal}"
sudo pacman -S thunar feh conky dmenu picom rofi volumeicon


# ============================= i3wm =============================
printf "${green}Installing i3wm...\n${normal}"
sudo pacman -S i3-gaps i3blocks i3status


# ============================= Audio =============================
printf "${green}Installing pavucontrol...\n${normal}"
sudo pacman -S pavucontrol


# ============================= Configs =============================
printf "${green}Installing i3wm configs...\n${normal}"
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