#!/bin/bash

# ============================= General Packages =============================
sudo pacman -S xorg xorg-server rsync btop mpv nextcloud-client packagekit-qt5 neofetch code usbutils wget numlockx ttf-font-awesome nerd-fonts arc-icon-theme arandr starship exa
sudo pacman -S fish
#sudo pacman -S zsh
sudo pacman -S jre-openjdk jdk-openjdk keepassxc gnome-keyring libsecret
sudo pacman -S libvirtd #VM
sudo pacman -S wpa_supplicant bluez bluez-utils #Wireless
sudo pacman -S avahi #Network Discovery
sudo pacman -S cups hplip #Printing
#sudo pacman -S acpid #Laptop

systemctl enable bluetooth
systemctl enable cups.service
systemctl enable avahi-daemon
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
#systemctl enable firewalld
#systemctl enable acpid


# ============================= Browsers =============================
sudo pacman -S firefox
paru -S librewolf


# ============================= Terminals =============================
#sudo pacman -S alacritty
paru -S wezterm


# ============================= Audio =============================
#sudo pacman -S pulseaudio pulseaudio-alsa
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber helvum qjackctl easyeffects pavucontrol
#paru -S noisetorch pipewire-jack-dropin


# ============================= Graphics =============================
sudo pacman -S nvidia nvidia-utils nvidia-settings nvidia-dkms
#sudo pacman -S amdvlk mesa


# ============================= DM =============================
paru -S lightdm-webkit-theme-aether
sudo systemctl enable lightdm
#sudo pacman -S sddm
#sudo systemctl enable sddm.service


# ============================= Shell =============================
#chsh -s $(which zsh)
chsh -s $(which fish)


# ============================= Hooks =============================
sudo mkdir /etc/pacman.d/hooks

echo "[Trigger]" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Operation = Upgrade" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Operation = Install" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Operation = Remove" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Type = Path" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Target = boot/*" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "[Action]" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Depends = rsync" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Description = Backing up /boot..." >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "When = PreTransaction" >> /etc/pacman.d/hooks/50-bootbackup.hook
echo "Exec = /usr/bin/rsync -a --delete /boot /.bootbackup" >> /etc/pacman.d/hooks/50-bootbackup.hook


# ============================= Keys =============================
ssh-keygen -t rsa -b 4096 -C "EMAIL"
eval "(ssh-agent -s)"
exec ssh-agent fish
#eval "$(ssh-agent -s)"
#exec ssh-agent zsh
ssh-add -K ~/.ssh/id_rsa


# ============================= Multilib =============================
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf


# ============================= Update =============================
sudo pacman -Syu