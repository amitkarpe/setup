#!/usr/bin/zsh

set -e

install_zsh () {
echo "Installation started"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cp ~/.zshrc ~/.zshrc.org
curl -o ~/.zshrc https://raw.githubusercontent.com/amitkarpe/setup/main/dot/.zshrc
curl -OL https://raw.githubusercontent.com/amitkarpe/setup/main/dot/.zshrc_extra
curl -o ~/.p10k.zsh https://raw.githubusercontent.com/amitkarpe/setup/main/dot/.p10k.zsh
sudo chsh -s /usr/bin/zsh ${USER}
setup_zsh;
source ~/.zshrc
}

setup_zsh () {
echo "LC_ALL=en_US.UTF-8" | sudo tee -a /etc/environment
echo "LANG=en_US.utf-8" | sudo tee -a /etc/environment

echo "Setup started"
#source ~/.zshrc

#git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
#echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
# https://github.com/romkatv/powerlevel10k
#curl -o ~/.p10k.zsh https://raw.githubusercontent.com/amitkarpe/setup/main/.p10k.zsh
# p10k configure

#mv ~/.zshrc ~/.zshrc.org
#cp ~/.zshrc ~/.zshrc.org
#curl -o ~/.zshrc https://raw.githubusercontent.com/amitkarpe/setup/main/.zshrc
#curl -o ~/.zshrc_extra https://raw.githubusercontent.com/amitkarpe/setup/main/.zshrc_extra
#curl -o ~/.oh-my-zsh/zsh-linux.sh https://raw.githubusercontent.com/amitkarpe/setup/main/zsh-linux.sh

cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-syntax-highlighting
cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-autosuggestions
cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/jonmosco/kube-ps1
cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-completions
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
git clone https://github.com/lincheney/fzf-tab-completion.git ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/fzf-tab-completion

(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
  echo "\n\n\nkubectl krew install applier colorize-applied confirm ns ctx \n\n\n"
  kubectl krew install applier colorize-applied confirm ns ctx || true
)

echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ~/.zshrc
echo 'alias kctx="kubectl-ctx"
alias k="kubectl"
alias kns="kubectl-ns"'  >> ~/.zshrc
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
echo "Run: source ~/.zshrc"

}

uninstall_zsh () {
rm -rf ~/.oh-my-zsh/
rm -v .zsh_history .zcompdump* .zshrc
}

main () {
  zsh
  install_zsh
#  setup_zsh
  
}

main
