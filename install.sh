#!/bin/bash

packages=("picom" "nitrogen" "ttf-font-awesome" "awesome-terminal-fonts" "awesome")

installPackage() {
  sudo pacman -S $1 --noconfirm 
}

installConfig() {
  mkdir -p $HOME/.config/awesome/
  cp awesome/* $HOME/.config/awesome -r
}

customiseConfig() {
  read -p "Terminal: " terminal
  read -p "Browser: " browser

  sed -i -e "s/alacritty/$terminal/g" $HOME/.config/awesome/rc.lua
  sed -i -e "s/brave/$browser/g" $HOME/.config/awesome/rc.lua
}

installLain() {
  git clone https://github.com/lcpz/lain $HOME/.config/awesome/lain/
}

for package in "${packages[@]}"
do
  installPackage $package
done

installConfig
customiseConfig
installLain
