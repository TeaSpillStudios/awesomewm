#!/bin/bash

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

  sed -i -e "s/alacritty/$terminal/g" $HOME/.config/awesome/rc.lua
  sed -i -e "s/brave/$browser/g" $HOME/.config/awesome/rc.lua
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
