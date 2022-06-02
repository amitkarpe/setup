#!/usr/bin/bash

set -e

install () {

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

zsh
source ~/.zshrc

# echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
# https://github.com/romkatv/powerlevel10k
# p10k configure

curl -o $ZSH/zsh-linux.sh https://raw.githubusercontent.com/amitkarpe/setup/main/zsh-linux.sh
source $ZSH/zsh-linux.sh

}

main () {
  install
  
}

main
