#!/bin/bash

sudo ./arch-xorg.sh

sudo pacman -S thunar feh conky dmenu picom rofi volumeicon
sudo pacman -S i3-gaps i3blocks i3status
cd ~
git clone https://github.com/rassweiler/dotfiles.git
cd dotfiles
./install
cd ..
sudo pacman -Syu
sudo pacman -S steam wine lutris wine-mono
paru -S proton proton-ge-custom mangohud streamdeck-ui
paru -S obs-studio-tytan652
paru -S betterdiscord-installer