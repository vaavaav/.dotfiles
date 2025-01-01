#!/bin/bash
CWD="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"

# <dotfile_relative_path> <absolute_path>
dotfiles=(
  ".bash_profile     $HOME"
  ".bashrc           $HOME"
  ".gitconfig        $HOME"
  ".tmux.conf        $HOME"
  ".xinitrc          $HOME"
  "101-keyboard.conf /etc/X11/xorg.conf.d"
  "alacritty.toml    $HOME/.config"
  "fontconfig        $HOME/.config"
  "gtk-3.0           $HOME/.config"
  "i3                $HOME/.config"
  "lightdm           /etc"
  "nvim              $HOME/.config"
  "pacman.conf       /etc"
  "picom.conf        $HOME/.config"
  "polybar           $HOME/.config"
  "rofi              $HOME/.config"
)

# Create a symlink from source to destination
function symlink {
  mkdir -p "$(dirname $2)" && ln -sf "$1" "$2"
  if [ $? -ne 0 ]; then
    echo "Failed to link $1 -> $2"
    echo "Would you like to retry with sudo? [y/n]"
    read -r response
    if [[ "$response" == "y" ]]; then
      sudo bash -c "mkdir -p '$(dirname $2)' && ln -sf $1 $2"
      echo "Symlinked $1 -> $2"
    else
      echo "Skipping $1 -> $2"
    fi
  else
    echo "Symlinked $1 -> $2/$(basename $1)"
  fi
}

for d in "${dotfiles[@]}"; do
  set -- $d
  if [ "$(stat -c %F $CWD/$1)" == "directory" ]; then
    for f in $CWD/$1/*; do
      symlink "$f" "$2/$1/$(basename $f)"
    done
  else
    symlink "$CWD/$1" "$2/$1"
  fi
done
