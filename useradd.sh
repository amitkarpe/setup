#!/usr/bin/bash

set -e
# set -x

export new=$1
sudo useradd --create-home $new --groups wheel --shell /usr/bin/zsh --password 1
#sudo usermod -s /usr/bin/zsh -a -G docker,wheel $new
echo " $new ALL=(ALL)   NOPASSWD: ALL"  | sudo tee -a  /etc/sudoers
