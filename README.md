# Dotfiles Manager

This tool is a small and simple dotfile manager written in Python.

It manages configuration files and directories, and supports:

- Collecting config files and directories into a `dotfiles/` directory
- Installing them back to their original locations
- Interactive overwrite confirmation (`yes`, `no`, `bak`)
- Optional `.bak` backup creation
- Installing only selected configs

## Requirements

- Python `3.11` or higher

## Directory Structure

Example:

```text
.
├── dotfiles
│   ├── nvim
│   │   ├── init.lua
│   │   ├── lua
│   ├── tmux.conf
│   └── zshrc
├── manager.py
├── README.md
└── targets.toml
```

- `manager.py` : the main script
- `targets.toml` : configuration file
- `dotfiles/` : stored configuration files/directories

### Configuration (`targets.toml`)

```toml
[nvim]
src = "~/.config/nvim/"
dest = "nvim/"

[zsh]
src = "~/.zshrc"
dest = "zshrc"

[tmux]
src = "~/.tmux.conf"
dest = "tmux.conf"
```

#### Fields

| Key  | Description                           |
| ---- | ------------------------------------- |
| src  | Original configuration file/directory |
| dest | Directory name inside `dotfiles/`     |

Notes:

- `~` is automatically expanded to your home directory
- Each top-level table name (e.g.,, `nvim`, `zsh`) is treated as the target name

## Commands

### Collect (copy configs into `dotfiles/`)

```bash
python manager.py collect
```

This copies all configured `src` files/directories into `./dotfiles/<dest>`

### Install (copy configs back)

```bash
# Install all configs
python manager.py install

# Install only specific configs (e.g., nvim and zsh)
python manager.py install nvim zsh
```

#### Overwrite Confirmation

When installing if the destination already exists, you will be asked:
`Overwrite /path/to/config-destination? [(y)es, (s)kip, (b)ackup]:`

| Input | Behavior                           |
| ----- | ---------------------------------- |
| `y`   | overwrite immediately              |
| `s`   | skip this config                   |
| `b`   | Create a backup before overwriting |

## Example Workflow

```bash
# 1. Collect configs from the system
python manager.py collect

# 2. Coommit dotfiles to git
git add dotfiles
git commit -m "Update dotfiles"

# 3. On a new environment, restore configs
python manager.py install
```
