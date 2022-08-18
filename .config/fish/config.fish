if status is-interactive
    # Commands to run in interactive sessions can go here
end

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.emacs.d/bin"

alias pacman="sudo pacman"
alias neofetch="neofetch --color_blocks off"
alias ls="ls -lah"
alias update="sudo pacman -Syyu && flatpak update"

#neofetch --ascii_distro slackware
#colorscript -r
./Documents/fetch/fetch.sh
