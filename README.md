# ndm-dev-docker

Containerize my personal dev environment.

A single `debian:trixie`-based image, built once and reused as the base for
multiple local containers. Each container is a personal, isolated dev
environment accessed via `docker exec -it`, running as a non-root `nirmal`
user with no sudo.

## What's in the image

- apt: curl, git, zsh (default shell for `nirmal`), plus the build tools
  Homebrew needs on Linux (build-essential, procps, file)
- [dotfiles](https://github.com/nirmal-mekala/dotfiles) cloned to
  `~/.dotfiles`, set up via its `setup_dotfiles` script
- Homebrew (Linuxbrew), with packages: fnm, eza, neofetch, neovim, tmux, fzf,
  fx, ripgrep, fff, bat, moreutils, glow, bun, deno, gum, jq, luarocks
- Node 24 (via fnm), with `claude` and `copilot` installed globally via npm
- [powerlevel10k](https://github.com/romkatv/powerlevel10k) cloned to
  `~/powerlevel10k`

See `ctx/prompt/260812-docker-dev-image-v2.md` for the full design rationale.

## Build

```sh
docker build -t ndm-dev-docker .
```

## Run

Containers are meant to be created per-project via Compose, not `docker run`
directly, so each gets its own persistent volume. See
`ctx/support/260812-sample-compose.yml` for an example with two containers
sharing the same image.

```sh
docker compose -f ctx/support/260812-sample-compose.yml up -d
docker exec -it nirmal-dev-a zsh
```

## Notes

- No sudo is installed for `nirmal`. System-level (apt) changes are made by
  rebuilding the image, not by patching a running container.
- Nothing is persisted by the image itself — volumes are configured
  per-container in a compose file.
