#!/usr/bin/zsh

set -e

install () {
sudo usermod $USER -s /usr/bin/zsh
zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

source ~/.zshrc

# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
# https://github.com/romkatv/powerlevel10k
# p10k configure

curl -o ~/.zshrc https://raw.githubusercontent.com/amitkarpe/setup/main/.zshrc
curl -o ~/.oh-my-zsh/zsh-linux.sh https://raw.githubusercontent.com/amitkarpe/setup/main/zsh-linux.sh

cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-syntax-highlighting
cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-autosuggestions


}

main () {
  install
  
}

main
