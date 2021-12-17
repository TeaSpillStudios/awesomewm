#!/bin/bash

# --- Update system --------------------------------

if [ -f "/etc/arch-release" ]; then 
  sudo pacman -Sy
else

  echo Only arch is supported at the moment

#  if [ -f "/etc/apt/source.list" ] then
#    sudo apt update; sudo apt upgrade -y
#  fi
fi

# --------------------------------------------------


# --- Wipe original configs ------------------------

sudo rm ~/.config/awesome -r

# --------------------------------------------------


# --- Install rofi config files --------------------

mkdir -p ~/.config/rofi

cp ./config.rasi ~/.config/rofi/

# --------------------------------------------------


# --- Read contents of package file into array -----

packageFile=packages

declare -a packageArray

mapfile -t packageArray < ./packages              

# --------------------------------------------------

# --- Function to install packages without prompt -- 
installPackage() {
  yes | sudo pacman -S $1 --noconfirm 
}

# -------------------------------------------------- 


# --- Copy configs to config folder ----------------

installConfig() {
  mkdir -p $HOME/.config/awesome/
  cp awesome/* $HOME/.config/awesome -r
}

# --------------------------------------------------  


# --- Replace variables in config file -------------

customiseConfig() {
  read -p "Terminal: " terminal
  read -p "Browser: " browser
  read -p "Keyboard layout: " keyboard

  echo "Commonly used layout:\nUS - United States\nGB - Great Britain (UK)\nnl - Netherlands\nSE - Sweden"

  sed -i -e "s/alacritty/$terminal/g" $HOME/.config/awesome/rc.lua
  sed -i -e "s/brave/$browser/g" $HOME/.config/awesome/rc.lua
  sed -i -e "s/setxkbmap gb/setxkbmap ${keyboard,,}/g" ~/.config/awesome/rc.lua
}

# --------------------------------------------------


# --- Setup the lain module to AwesomeWM -----------

installLain() {
  git clone https://github.com/lcpz/lain $HOME/.config/awesome/lain/
}

# --------------------------------------------------

# --- Main function to run -------------------------

main() {
  for package in "${packageArray[@]}"
  do
    installPackage $package
  done

  installConfig
  customiseConfig
  installLain
}

# --------------------------------------------------


# --- Run the main function ------------------------

main

# --------------------------------------------------
