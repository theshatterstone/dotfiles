if status is-interactive
    # Commands to run in interactive sessions can go here
end

export PATH="$HOME/.local/bin:$PATH"

alias pacman="sudo pacman"
alias neofetch="neofetch --color_blocks off"
alias ls="ls -lah"

#neofetch --ascii_distro nixos
colorscript -r
