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

# ============================= Battery =============================
printf "${green}Installing upower... (enter)\n${normal}"
read -p ""
sudo pacman -S acpi
#sudo pacman -S upower
#sudo systemctl enable upower
#sudo systemctl start upower


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