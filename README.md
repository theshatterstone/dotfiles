# dotfiles
My dotfiles

To Configure, replace your .config/ and .bashrc to mine. Applications required: 

Arch:

sudo pacman -S alacritty awesome conky htop nano neofetch nitrogen rofi dmenu thunar


Deb:

sudo apt install alacritty awesome conky htop nano neofetch nitrogen rofi dmenu thunar


Post-install:

cd dotfiles/

cp -r .config/ ~/

cp .bashrc ~/


If you have custom configurations in your .config folder, move the subdirectiories in my .config to your own. If I have any configurations that conflict with yours, move your directories to a temporary location to try out my setup. 

If rc.lua doesn't work, remember to try changing it to the alternative file offered outside my .config directory. If you're still having problems, try rc.lua from backup/ directory.
