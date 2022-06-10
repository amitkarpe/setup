#!/usr/bin/zsh

set -e

install () {
echo "Installation started"

sudo usermod $USER -s /usr/bin/zsh
#zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
exit 0;
}

setup () {

echo "Setup started"
#source ~/.zshrc

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
# https://github.com/romkatv/powerlevel10k
curl -o ~/.p10k.zsh https://raw.githubusercontent.com/amitkarpe/setup/main/.p10k.zsh
# p10k configure

mv ~/.zshrc ~/.zshrc.org
#curl -o ~/.zshrc https://raw.githubusercontent.com/amitkarpe/setup/main/.zshrc
#curl -o ~/.oh-my-zsh/zsh-linux.sh https://raw.githubusercontent.com/amitkarpe/setup/main/zsh-linux.sh

cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-syntax-highlighting
cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-autosuggestions

echo "Run: source ~/.zshrc"

}

uninstall () {
rm -rf ~/.oh-my-zsh/
rm -v .zsh_history .zcompdump* .zshrc
}

main () {
  install
  setup
  
}

main
