#!/bin/bash

# --- Update system --------------------------------

if [ -f "/etc/arch-release" ]; then 
  sudo pacman -Sy
else
  if [ -f "/etc/apt/source.list" ]; then
    sudo apt update; sudo apt upgrade -y
  fi
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
  if [ -f "/etc/arch-release" ]; then
    yes | sudo pacman -S $1 --noconfirm 
  else
    if [ -f "/etc/apt/sources.list" ]; then
      sudo apt install $1 -y
    fi
  fi
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

  echo '
Pre-installed packages:
  alacritty
  kitty
'

  read -p "Terminal: " terminal

  echo '
Pre-installed packages:
  firefox
'

  read -p "Browser: " browser

  echo '
Commonly used layout:
  US - United States
  GB - Great Britain (UK)
  NL - Netherlands
  SE - Sweden
'

  read -p "Keyboard layout: " keyboard

  sed -i -e "s/alacritty/${terminal,,}/g" $HOME/.config/awesome/rc.lua
  sed -i -e "s/brave/${browser,,}/g" $HOME/.config/awesome/rc.lua
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
  installLain
  customiseConfig
}

# --------------------------------------------------


# --- Run the main function ------------------------

main

# --------------------------------------------------


# --- Say thank you to the user at the end ---------

echo '
Awesome is now isnstalled and themed!

Thank you for using this script! I hope you enjoy your new setup.
'

# --------------------------------------------------
