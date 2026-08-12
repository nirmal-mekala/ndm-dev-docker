### prompt

we are creating a docker image

the goal of the docker image is to be a personal development environment that i
can access and work in that is isolated from my system

important pieces:
- latest debian (trixie) for the base
- "nirmal" user set up. everything that follows is scoped to the "nirmal" user
  - user should not have passwordless sudo
- core stuff set up with apt
  - curl
  - git
- github.com/nirmal-mekala/dotfiles cloned to /home/nirmal/.dotfiles
  - `setup_dotfiles` script within this repo called
- brew package manager installed
  - brew set up in .localshrc
  - brew packages installed
    - fnm
    - eza
    - neofetch
    - neovim
    - tmux
    - fzf
    - fx
    - ripgrep
    - fff
    - bat
    - moreutils
    - glow
    - bun
    - deno
    - gum
    - jq
    - luarocks
- agents installed
  - claude
  - copilot
- fnm installed (brew)
  - fnm config'd in ~/.localshrc, not ~/.zshrc
- zsh set up and configured as default shell
- powerlevel10k cloned to /home/nirmal/powerlevel10k
  - `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k`
