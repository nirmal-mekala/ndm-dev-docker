### prompt

we are creating a docker image

the goal of the docker image is to be a personal development environment that i
can access and work in that is isolated from my system

usage model: a single image, built once, used as the base for multiple
containers created locally (e.g. via a compose file). per-container
differences (passwords, volumes, etc.) should be handled at container
creation/runtime, not baked into the image itself.

access: `docker exec -it` into a running container. the image just needs to
stay running (e.g. `sleep infinity` / `tail -f /dev/null`), no SSH server
needed.

persistence: none baked into the image. any volumes (e.g. for project code,
shell history) will be configured per-container, likely in a compose file, and
are out of scope for this Dockerfile.

### build order (logical layering)

1. base image: `debian:trixie`
2. apt packages (as root)
   - curl
   - git
   - zsh
   - build-essential
   - procps
   - file
   (last three are prerequisites for Linuxbrew; grouped here since they're all
   apt-installed "core stuff")
3. create "nirmal" user
   - `useradd -s $(which zsh)` (or equivalent) so zsh is the default shell from
     creation, rather than a separate `chsh` step
   - no sudo at all (not even with a password) — decided this is viable for
     node/react agentic dev work, since node/npm/brew are all installed
     user-locally and don't need root at runtime; any apt-level changes get
     made by rebuilding the image rather than patching a running container
4. everything from here on is scoped to the "nirmal" user
5. clone github.com/nirmal-mekala/dotfiles to /home/nirmal/.dotfiles
   - run the `setup_dotfiles` script from within this repo
6. install brew (Linuxbrew)
   - brew set up in .localshrc (not .zshrc)
7. install brew packages
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
   - fnm config'd in ~/.localshrc (not ~/.zshrc)
8. install node 24 via fnm, then `npm install -g` the agents
   - claude
   - copilot
9. clone powerlevel10k to /home/nirmal/powerlevel10k
   - `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k`

### decisions confirmed

- no sudo for "nirmal", full stop. viable for node/react agentic dev since
  node/npm/brew packages all install and run user-locally; system-level
  changes are handled by rebuilding the image, not by patching a live
  container.
- brew's apt prerequisites on Debian (build-essential, procps, file, in
  addition to curl and git already listed) confirmed against Homebrew's own
  docs (docs.brew.sh/Homebrew-on-Linux).
- node 24 via fnm, before the npm global agent installs.
- a sample compose file is at ctx/support/260812-sample-compose.yml,
  demonstrating per-container volumes for a container built from this image.
