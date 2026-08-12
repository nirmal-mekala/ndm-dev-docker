FROM debian:trixie

# ---- core apt packages ----
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        git \
        zsh \
        build-essential \
        procps \
        file \
        ca-certificates \
        openssh-client \
    && rm -rf /var/lib/apt/lists/*

# ---- "nirmal" user, no sudo ----
RUN useradd -m -s "$(command -v zsh)" nirmal

# Homebrew refuses to install as root, but also needs its prefix directory
# created before the non-root install step below. Pre-create and hand it off
# to nirmal here; everything else happens as nirmal.
RUN mkdir -p /home/linuxbrew/.linuxbrew \
    && chown -R nirmal:nirmal /home/linuxbrew/.linuxbrew

# ---- everything below is scoped to "nirmal" ----
USER nirmal
WORKDIR /home/nirmal
SHELL ["/bin/bash", "-c"]

# ---- ssh client config ----
# Home directory is expected to be mounted as a volume (persisting keys across
# restarts), so this just seeds the expected layout/perms for the initial
# volume population; it doesn't create any keys itself.
RUN mkdir -p /home/nirmal/.ssh && chmod 700 /home/nirmal/.ssh

# ---- dotfiles ----
RUN git clone https://github.com/nirmal-mekala/dotfiles.git /home/nirmal/.dotfiles \
    && /home/nirmal/.dotfiles/setup_dotfiles

# ---- Homebrew (Linuxbrew) ----
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/nirmal/.localshrc

# ---- brew packages ----
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew install \
        fnm \
        eza \
        neofetch \
        neovim \
        tmux \
        fzf \
        fx \
        ripgrep \
        fff \
        bat \
        moreutils \
        glow \
        bun \
        deno \
        gum \
        jq \
        luarocks \
    && echo 'eval "$(fnm env --use-on-cd)"' >> /home/nirmal/.localshrc

# ---- node 24 + agents ----
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && eval "$(fnm env)" \
    && fnm install 24 \
    && fnm default 24 \
    && eval "$(fnm env)" \
    && npm install -g @anthropic-ai/claude-code @github/copilot

# ---- powerlevel10k ----
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/nirmal/powerlevel10k

CMD ["sleep", "infinity"]
