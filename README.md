# devenv

A portable Docker-based Arch Linux development environment with [opencode](https://github.com/anomalyco/opencode), [shell-gpt](https://github.com/TheR1D/shell_gpt), [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh), and [powerlevel10k](https://github.com/romkatv/powerlevel10k).

## Why?

- **Reproducible**: Spin up a fresh dev environment anywhere Docker runs
- **Portable**: Your dotfiles and workspace follow you between machines
- **Clean**: Separate your config (dotfiles) from your projects (workspace)
- **Fast**: Uses `archlinux:base-devel` as the base image

## Quick Start

```bash
# 1. Build the Docker image (with your UID/GID for correct file permissions)
docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t devenv -f container/Dockerfile .

# 2. (Optional) Copy example config files for opencode and sgpt, then edit with your API keys
cp dotfiles/opencode.json.example dotfiles/opencode.json
cp dotfiles/sgptrc.example dotfiles/sgptrc

# 3. Start the container
docker compose -f container/compose.yml up -d

# 4. Enter the shell
docker compose -f container/compose.yml exec devenv /bin/zsh
```

Or use the helper script: `./run.sh build && ./run.sh up && ./run.sh attach`.

That's it! You'll be in an Arch Linux container with:
- [opencode](https://github.com/anomalyco/opencode) CLI tool
- [shell-gpt](https://github.com/TheR1D/shell_gpt) (sgpt) for AI assistance
- [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) + [powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
- zsh plugins (autosuggestions, history search, F-Sy-H)
- Your dotfiles, workspace, and share folder mounted

## Project Structure

```
devenv/
├── container/
│   ├── Dockerfile       # Image definition
│   └── compose.yml      # Container setup
├── dotfiles/            # Your config files (mounted to ~/dotfiles)
├── workspace/           # Your projects (mounted to ~/workspace)
├── share/               # Shared files for transfer (mounted to ~/share)
├── bootstrap/           # Setup scripts
└── README.md
```

## Usage

```bash
# Build image (pass your UID/GID for correct file ownership)
docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t devenv -f container/Dockerfile .

# Start container
docker compose -f container/compose.yml up -d

# Enter shell
docker compose -f container/compose.yml exec devenv /bin/zsh

# Stop container (keeps data)
docker compose -f container/compose.yml stop

# Remove container (deletes container, keeps data volumes)
docker compose -f container/compose.yml down
```

Or use `./run.sh` (build/up/down/stop/attach/exec).

## What's Inside?

### Dockerfile (build time)
| Component | Description |
|-----------|-------------|
| Base image | `archlinux:base-devel` |
| Shell | zsh with [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) |
| Theme | [powerlevel10k](https://github.com/romkatv/powerlevel10k) (Pure style) |
| Plugins | zsh-autosuggestions, zsh-history-substring-search, F-Sy-H, z |

### bootstrap.sh (runtime)
| Component | Description |
|-----------|-------------|
| CLI tool | [opencode](https://github.com/anomalyco/opencode) |
| Symlinks | zshrc, gitconfig, gitignore_global |

## Persistence

- **Dotfiles**: Stored in `./dotfiles/` on host, mounted to `~/dotfiles` in container
- **Workspace**: Your projects live in `./workspace/` on host, accessible at `~/workspace` in container
- **Share**: Files for transfer live in `./share/` on host, accessible at `~/share` in container

## User & Permissions

The container runs as a non-root user `devenv` with your host UID/GID. This ensures:
- Files created in `workspace/`, `dotfiles/`, and `share/` are owned by your host user
- No permission issues when editing files from both host and container

If your host UID differs from 1000, always build with:
```bash
docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t devenv -f container/Dockerfile .
```

## Customization

### Symlinks

On container start, `bootstrap.sh` creates the following symlinks:

| Source | Target |
|--------|--------|
| `~/dotfiles/zshrc` | `~/.zshrc` |
| `~/dotfiles/gitconfig` | `~/.gitconfig` |
| `~/dotfiles/gitignore_global` | `~/.gitignore_global` |

Additionally, these files are copied (not symlinked):
- `~/dotfiles/opencode.json` → `~/.opencode/opencode.json`
- `~/dotfiles/sgptrc` → `~/.config/shell_gpt/.sgptrc`

### Adding your own dotfiles

Edit the files in `dotfiles/`. They are directly accessible in the container at `~/dotfiles/`.

The main files:
- `zshrc` - Main zsh configuration
- `p10k.zsh` - Powerlevel10k prompt config
- `gitconfig` - Git settings
- `aliases.sh`, `vars.sh`, `functions.sh` - Your custom shell config

### Git Configuration

The `dotfiles/gitconfig` file is symlinked to `~/.gitconfig` on container start (via `bootstrap.sh`).

Default settings include:
- `init.defaultBranch = main`
- `credential.helper = store`
- `core.editor = nano`
- Global gitignore via `core.excludesfile`
- Custom aliases: `fm`, `fp`

**Important**: Edit `dotfiles/gitconfig` to set your own `user.name` and `user.email`.

### Adding packages

Edit `bootstrap/packages-arch.txt` and add your packages (one per line, comments start with #). The packages will be installed during Docker build.

## Requirements

- Docker
- docker compose

## API Keys

To use opencode and shell-gpt (sgpt), copy the example config files and add your API keys:

```bash
cp dotfiles/opencode.json.example dotfiles/opencode.json
cp dotfiles/sgptrc.example dotfiles/sgptrc
```

Then edit `dotfiles/opencode.json` and `dotfiles/sgptrc` to replace the placeholder API keys with your own. Supported providers include OpenRouter, Anthropic, and Agent Zero.