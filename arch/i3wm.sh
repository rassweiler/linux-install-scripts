#!/bin/bash

# ============================= Base =============================
./xorg-intel.sh
#./xorg-amd.sh


# ============================= GUI Packages =============================
sudo pacman -S thunar feh conky dmenu picom rofi volumeicon


# ============================= i3wm =============================
sudo pacman -S i3-gaps i3blocks i3status


# ============================= Audio =============================
sudo pacman -S pavucontrol


# ============================= Configs =============================
cd ~
git clone https://github.com/rassweiler/dotfiles.git
cd dotfiles
./install
cd ~


# ============================= Complete =============================
sudo pacman -Syu
read -p "Rebooting, enter to continue"
sudo reboot now