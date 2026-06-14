#!/bin/bash

# "collect" or "install"
arg="$1"

# Copy functions

copy_install() {
  local -n arr=$1
  local src="${arr[1]}"
  local dest="${arr[0]}"
  if [ ! "$src" ]; then
    echo "Source path is empty: $src"
    return 1
  fi
  cp -r "$src" "$dest"
  echo "Copied $src to $dest"
}

copy_collect() {
  local -n arr=$1
  local src="${arr[0]}"
  local dest="${arr[1]}"
  if [ ! "$src" ]; then
    echo "Source path is empty: $src"
    return 1
  fi
  cp -r "$src" "$dest"
  echo "Copied $src to $dest"
}

# ----------------------------------------------
# Edit Below
# ----------------------------------------------

# configuration files' path

_fish=(
  "$HOME/.config/fish/config.fish"
  "$(dirname "$0")/config.fish"
)

_tmux=(
  "$HOME/.tmux.conf"
  "$(dirname "$0")/tmux.conf"
)

_nvim=(
  "$HOME/.config/nvim/"
  "$(dirname "$0")/nvim/"
)

_skk_user=(
  "$HOME/.local/share/fcitx5/skk/user.dict"
  "$(dirname "$0")/user.dict"
)

_sway=(
  "$HOME/.config/sway/config"
  "$(dirname "$0")/sway_config"
)

# ----------------------------------------------

if [ "$arg" == "collect" ]; then
  # Collect configuration files
  echo "Collecting configuration files..."

  # --- Edit Below ---
  copy_collect _fish
  copy_collect _tmux
  copy_collect _nvim
  copy_collect _sway
  copy_collect _skk_user
  # -------------------

elif [ "$arg" == "install" ]; then
  # Install configuration files
  echo "Applying database migrations..."

  # --- Edit Below ---
  copy_install _fish
  copy_install _tmux
  copy_install _nvim
  copy_install _sway
  copy_install _skk_user
  # -------------------

else
  echo "Usage: $0 [collect|install]"
  exit 1
fi
