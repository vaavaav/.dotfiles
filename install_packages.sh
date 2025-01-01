#!/bin/bash

# Check if yay is already installed
if ! command -v yay &>/dev/null; then
  echo "Yay could not be found, installing..."
  sudo pacman -Syu --needed base-devel git
  git clone https://aur.archlinux.org/yay.git
  pushd yay
  makepkg -si
  popd
  rm -rf yay
  echo "Yay installation completed successfully."
fi

echo "Installing packages..."
yay -Syu --needed --color always \
  alacritty \
  alsa-utils \
  arandr \
  autenticacao-gov-pt-bin \
  biber \
  bitwarden \
  bluez-git \
  bluez-utils \
  brightnessctl \
  cargo \
  clang \
  cmake \
  cups \
  discord \
  dkms \
  drawio-desktop \
  elixir \
  feh \
  firefox \
  flameshot \
  font-manager \
  freeglut \
  fzf \
  gcc \
  ghc \
  ghcup-hs-bin \
  gnome-keyring \
  i3-wm \
  inter-font \
  jdk-openjdk \
  lightdm \
  lightdm-gtk-greeter \
  linux-headers \
  man-db \
  mupdf \
  neofetch \
  neovim \
  neovim-web-devicons-git \
  nerd-fonts-git \
  network-manager-applet \
  networkmanager-openvpn-git \
  noisetorch \
  noto-fonts-cjk \
  noto-fonts-emoji \
  nvim-packer-git \
  openssh-askpass \
  openvpn \
  pavucontrol \
  picom \
  playerctl \
  polybar \
  pulseaudio-bluetooth \
  rofi \
  rustup \
  spotify \
  stremio \
  system-config-printer \
  texlive-basic \
  texlive-bibtexextra \
  texlive-binextra \
  texlive-fontsextra \
  texlive-fontsrecommended \
  texlive-langportuguese \
  texlive-latex \
  texlive-latexextra \
  texlive-latexrecommended \
  texlive-luatex \
  texlive-mathscience \
  texlive-plaingeneric \
  thunderbird \
  tmux \
  tmux-plugin-manager \
  ttf-iosevka \
  ttf-material-design-icons-webfont \
  typst \
  unzip \
  vim \
  visual-studio-code-bin \
  wget \
  xclip \
  xorg-server \
  xorg-xinit \
  xorg-xwininfo \
  zotero
