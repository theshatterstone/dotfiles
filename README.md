# dotfiles
My dotfiles

To Configure, replace your .config/ and .bashrc to mine. 
Step 1: Download files:

git clone https://github.com/theshatterstone/dotfiles

step 2: Downloading Applications: 
Applications required: 

Arch:

sudo pacman -S alacritty awesome conky htop nano neofetch nitrogen rofi dmenu thunar qtile brightnessctl


Deb:

sudo apt install alacritty awesome conky htop nano neofetch nitrogen rofi dmenu thunar qtile brightnessctl


Post-install:

cd dotfiles/

cp -r * ~/

Additional apps/packages: picom telegram lxappearance xfce4-screenshooter blueberry code virt-manager archlinux-logout archlinux-tweak-tool discord firefox vlc deadbeef etcher gparted geany kdenlive meld notepadqq obs onlyoffice qbittorrent redshift ristretto stacer steam thunderbird tor ventoy lutris variety

NOTE:Qtile requires Ubuntu fonts installed. 
Qtile brightness and volume controls only work with the brightnessctl package installed and with the .local/ files from 
https://github.com/justinesmithies/qtile-x-dotfiles/ 


rc.lua should work now that I've finally gotten around to fixing these dotfiles. 
At the time of writing this paragraph, it's 10:54 UK time on the 30th May 2022, 
and I just want to declare proudly that this commit I'm about to do has had all of the changes 
done entirely in the terminal, while this Readme paragraph has been written in Vim. 
Safe to say I'm very proud of myself! I'm probably never removing this BTW.
