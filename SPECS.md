# devenv - Specification

A portable Docker-based Arch Linux development environment with zsh, oh-my-zsh, and essential dev tools.

## Project Overview

- **Project name**: devenv
- **Type**: Development environment (Docker-based)
- **Core functionality**: Containerized Arch Linux dev environment with dotfiles, persistent workspace, and share folder
- **Target users**: Developers who want a reproducible, portable dev environment

## Architecture

```
devenv/
├── container/           # Docker configuration
│   ├── Dockerfile       # Image build definition
│   └── compose.yml      # Container orchestration
├── dotfiles/            # User configuration (mounted to ~/dotfiles)
├── workspace/           # User projects (mounted to ~/workspace)
├── share/               # File transfer folder (mounted to ~/share)
├── bootstrap/           # Runtime setup scripts
│   ├── bootstrap.sh     # Symlink creation and config setup
│   └── packages-arch.txt # System packages to install
├── README.md            # Project documentation
├── QUICKSTART.md        # Command reference
└── LICENSE              # MIT License
```

## Docker Specification

### Base Image

- **Image**: `archlinux:base-devel`
- **Rationale**: Minimal base with development tools pre-installed

### User Setup

- **Username**: `devenv`
- **UID/GID**: Configurable via build args (defaults: 1000:1000)
- **Home**: `/home/devenv`
- **Shell**: zsh
- **Rationale**: Non-root user ensures files created in mounted volumes are owned by host user

Build args:
```
--build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g)
```

### System Packages

Install via `pacman` during image build (see `bootstrap/packages-arch.txt`):

| Package | Purpose |
|---------|---------|
| zsh | Interactive shell |
| git | Version control |
| nodejs | JavaScript runtime |
| npm | Node package manager |
| python-pipx | Python CLI tool installer |
| curl, wget | HTTP clients |
| nano | Text editor |
| fzf | Fuzzy finder |
| btop | System monitor |
| fastfetch | System info |
| jq, yq | JSON/YAML processors |
| rsync | File sync |
| sshfs, fuse2 | SSH filesystem |
| net-tools, inetutils | Network utilities |
| opencode | CLI tool for AI assistance |
| less | Pager |

### Shell Setup

1. **Shell**: zsh as default (`chsh -s /bin/zsh`)
2. **Framework**: oh-my-zsh (installed unattended)
3. **Theme**: powerlevel10k (Pure-style prompt)
4. **Plugins**:
   - zsh-autosuggestions
   - zsh-history-substring-search
   - F-Sy-H (syntax highlighting)
   - z (navigator)

### Additional Tools

- **shell-gpt**: Via `pipx install shell-gpt`
- **pnpm**: Via `npm install -g pnpm`

### Git Configuration

```bash
git config --global user.email "dev@container.local"
git config --global user.name "Dev Container"
git config --global init.defaultBranch main
```

### Environment Variables

```
GIT_TERMINAL_PROMPT=0
PATH="/home/devenv/.local/bin:${PATH}"
```

## Container Specification

### compose.yml

| Setting | Value |
|---------|-------|
| Service name | devenv |
| Container name | devenv |
| Restart policy | unless-stopped |
| User | ${UID:-1000}:${GID:-1000} |
| DNS | 8.8.8.8, 1.1.1.1 |
| Working directory | /home/devenv |
| TTY | enabled |
| Stdin open | enabled |

### Volume Mounts

| Host path | Container path | Purpose |
|-----------|----------------|---------|
| ../dotfiles | /home/devenv/dotfiles | User configs |
| ../workspace | /home/devenv/workspace | User projects |
| ../share | /home/devenv/share | File transfer |
| ../bootstrap | /home/devenv/bootstrap | Setup scripts |

### Entrypoint

Run bootstrap script, then start zsh:
```bash
sh -c "/home/devenv/bootstrap/bootstrap.sh && /bin/zsh"
```

## Bootstrap Specification

### bootstrap.sh

Executed on container start. Creates symlinks:

| Source | Target | Purpose |
|--------|--------|---------|
| ~/dotfiles/zshrc | ~/.zshrc | Zsh config |
| ~/dotfiles/gitconfig | ~/.gitconfig | Git config |
| ~/dotfiles/gitignore_global | ~/.gitignore_global | Git ignore |

Optional config copy:
- `dotfiles/opencode.json` → `~/.opencode/opencode.json`
- `dotfiles/sgptrc` → `~/.config/shell_gpt/.sgptrc`

## Persistence Strategy

| Data | Location | Persists |
|------|----------|----------|
| Dotfiles | `./dotfiles/` on host | Yes (mounted r/w) |
| Workspace | `./workspace/` on host | Yes (mounted r/w) |
| Share | `./share/` on host | Yes (mounted r/w) |
| Shell history | `~/dotfiles/zsh_history` | Yes (in dotfiles) |

## Usage

```bash
# Build image (pass your UID/GID for correct file ownership)
docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t devenv -f container/Dockerfile .

# Start container
docker compose -f container/compose.yml up -d

# Enter shell
docker compose -f container/compose.yml exec devenv /bin/zsh

# Stop container
docker compose -f container/compose.yml down
```

## Requirements

- Docker
- docker compose

## Future Considerations

- GPU passthrough for ML dev
- Customizable plugins list
- Template system for workspace initialization
