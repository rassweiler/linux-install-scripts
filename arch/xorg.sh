#!/bin/bash
blue=$(tput setaf 4)
red=$(tput setaf 1)
green=$(tput setaf 2)
normal=$(tput sgr0)


# ============================= Input =============================
printf "${blue}Enter Username:\n${normal}"
read username
echo "Username: ${username}"


# ============================= Snapshots =============================
printf "${green}Fixing snapshots...\n${normal}"
read -p ""
sudo umount /.snapshots
sudo rm -r /.snapshots
sudo snapper -c root create-config /
sudo btrfs su del /.snapshots
sudo mkdir /.snapshots
sudo mount -a
sudo chmod 750 /.snapshots
sudo chmod a+rx /.snapshots
sudo chown :${username} /.snapshots
printf "${red}Editing Snapper Config add user to allowed, enter to continue...\n${normal}"
read -p ""
sudo nano /etc/snapper/configs/root
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer


# ============================= Yay =============================
#cd ~
#git clone https://aur.archlinux.org/yay
#cd yay
#makepkg -si PKGBUILD
#cd ~


# ============================= Paru =============================
printf "${green}Installing Paru...\n${normal}"
read -p ""
cd ~
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ~


# ============================= Snapshots Grub =============================
printf "${green}Installing Snap Pac Grub...\n${normal}"
read -p ""
#yay -S snap-pac-grub snapper-gui
paru -S snap-pac-grub snapper-gui


# ============================= General Packages =============================
printf "${green}Installing General Packages...\n${normal}"
read -p ""
sudo pacman -S xorg xorg-server rsync btop mpv nextcloud-client packagekit-qt5 neofetch code usbutils wget numlockx ttf-font-awesome nerd-fonts arc-icon-theme arandr starship exa
sudo pacman -S fish
#sudo pacman -S zsh
sudo pacman -S jre-openjdk jdk-openjdk keepassxc gnome-keyring libsecret
sudo pacman -S qemu libvirt ovmf virt-manager ebtables dnsmasq #VM
sudo pacman -S wpa_supplicant bluez bluez-utils #Wireless
sudo pacman -S avahi #Network Discovery
sudo pacman -S cups hplip #Printing
#sudo pacman -S acpid #Laptop
sudo systemctl enable bluetooth
sudo systemctl enable cups.service
sudo systemctl enable avahi-daemon
sudo systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
sudo systemctl enable reflector.timer
sudo systemctl enable fstrim.timer
sudo systemctl enable libvirtd
#sudo systemctl enable firewalld
#sudo systemctl enable acpid


# ============================= VM =============================
printf "${green}Setting up vm systems...\n${normal}"
read -p ""
sudo pacman -S qemu libvirt ovmf virt-manager ebtables dnsmasq #VM
sudo systemctl enable libvirtd
sudo systemctl enable virtlogd.socket
sudo usermod -aG libvirt ${username}
sudo virsh net-autostart default


# ============================= Browsers =============================
printf "${green}Installing browsers...\n${normal}"
read -p ""
sudo pacman -S firefox
paru -S librewolf


# ============================= Terminals =============================
printf "${green}Installing termil...\n${normal}"
read -p ""
#sudo pacman -S alacritty
paru -S wezterm


# ============================= Audio =============================
printf "${green}Installing audio...\n${normal}"
read -p ""
#sudo pacman -S pulseaudio pulseaudio-alsa pulseaudio-bluetooth
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber helvum qjackctl easyeffects
#paru -S noisetorch pipewire-jack-dropin


# ============================= Graphics =============================
printf "${green}Installing graphics...\n${normal}"
read -p ""
sudo pacman -S nvidia nvidia-utils nvidia-settings nvidia-dkms
#sudo pacman -S amdvlk mesa


# ============================= Mkinitcpio =============================
printf "${green}Update mkinitcpio...\n${normal}"
read -p ""
printf "${red}Add graphics to modules (amdgpu, nvidia), enter to continue...\n${normal}"
read -p ""
sudo nano /etc/mkinitcpio.conf
sudo mkinitcpio -p linux-zen


# ============================= DM =============================
printf "${green}Install DM...\n${normal}"
read -p ""
paru -S lightdm-webkit-theme-aether
sudo systemctl enable lightdm
#sudo pacman -S sddm
#sudo systemctl enable sddm.service


# ============================= Shell =============================
printf "${green}Set Shell...\n${normal}"
read -p ""
#chsh -s $(which zsh)
chsh -s $(which fish)


# ============================= Hooks =============================
printf "${green}Setup Hooks...\n${normal}"
read -p ""
sudo mkdir /etc/pacman.d/hooks
echo "[Trigger]" | sudo tee -a /etc/pacman.d/hooks/50-bootbackup.hook
echo "Operation = Upgrade" | sudo tee -a /etc/pacman.d/hooks/50-bootbackup.hook
echo "Operation = Install" | sudo tee -a /etc/pacman.d/hooks/50-bootbackup.hook
echo "Operation = Remove" | sudo tee -a /etc/pacman.d/hooks/50-bootbackup.hook
echo "Type = Path" | sudo tee -a /etc/pacman.d/hooks/50-bootbackup.hook
echo "Target = boot/*" | sudo tee -a /etc/pacman.d/hooks/50-bootbackup.hook
echo "" | sudo tee -a /etc/pacman.d/hooks/50-bootbackup.hook
echo "[Action]" | sudo tee -a /etc/pacman.d/hooks/50-bootbackup.hook
echo "Depends = rsync" | sudo tee -a /etc/pacman.d/hooks/50-bootbackup.hook
echo "Description = Backing up /boot..." | sudo tee -a /etc/pacman.d/hooks/50-bootbackup.hook
echo "When = PreTransaction" | sudo tee -a /etc/pacman.d/hooks/50-bootbackup.hook
echo "Exec = /usr/bin/rsync -a --delete /boot /.bootbackup" | sudo tee -a /etc/pacman.d/hooks/50-bootbackup.hook


# ============================= Keys =============================
printf "${green}Setup SSH Keys...\n${normal}"
read -p ""
echo "Enter Email For SSH Key: "
read email
echo "Email: ${email}"
ssh-keygen -t rsa -b 4096 -C "${email}"
eval "(ssh-agent -s)"
#exec ssh-agent fish
#eval "$(ssh-agent -s)"
#exec ssh-agent zsh
#ssh-add -K ~/.ssh/id_rsa


# ============================= Multilib =============================
printf "${green}Enable Multilib...\n${normal}"
read -p ""
echo "[multilib]" | sudo tee -a /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
sudo pacman -Syu


# ============================= Gaming =============================
printf "${green}Setup Gaming...\n${normal}"
read -p ""
sudo pacman -S steam wine lutris wine-mono
paru -S proton proton-ge-custom
paru -S mangohud
#paru -S streamdeck-ui
paru -S obs-studio-tytan652
sudo pacman -S discord
paru -S betterdiscord-installer


# ============================= Update User =============================
sudo usermod -aG audio ${username}
sudo usermod -aG video ${username}