#!/usr/bin/zsh

set -e

install_brew () {
  # if brew command is not install then install brew
  if ! command -v brew &> /dev/null
  then
    echo "brew command is not installed"
    echo "installing brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.zshrc
  else
    echo "brew command is installed"
  fi
}

# install git
install_git () {
  if ! command -v git &> /dev/null
  then
    echo "git command is not installed"
    echo "installing git"
    brew install git
    curl -O https://raw.githubusercontent.com/amitkarpe/setup/main/dot/.gitignore_global
    curl -O https://raw.githubusercontent.com/amitkarpe/setup/main/dot/.gitconfig
  else
    echo "git command is installed"
  fi
}

# install warp using brew
install_warp () {
  if ! command -v warp &> /dev/null
  then
    echo "warp command is not installed"
    echo "installing warp"
    brew install --cask warp
  else
    echo "warp command is installed"
  fi
}

# install fig using brew
install_fig () {
  if ! command -v fig &> /dev/null
  then
    echo "fig command is not installed"
    echo "installing fig"
    brew install --cask fig
  else
    echo "fig command is installed"
  fi
}

# install iterm2 using brew
install_iterm2 () {
  if ! command -v iterm2 &> /dev/null
  then
    echo "iterm2 command is not installed"
    echo "installing iterm2"
    brew install --cask iterm2
  else
    echo "iterm2 command is installed"
  fi
}

# install vscode using brew
install_vscode () {
  if ! command -v vscode &> /dev/null
  then
    echo "vscode command is not installed"
    echo "installing vscode"
    # brew install --cask vscode
    brew install --cask visual-studio-code
  else
    echo "vscode command is installed"
  fi
}

# install oh-my-zsh
install_ohmyzsh () {
  if ! command -v ohmyzsh &> /dev/null
  then
    echo "ohmyzsh command is not installed"
    echo "installing ohmyzsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    exec zsh
  else
    echo "ohmyzsh command is installed"
  fi
}

# install zsh-autosuggestions
install_zshautosuggestions () {
  if ! command -v zsh-autosuggestions &> /dev/null
  then
    echo "zsh-autosuggestions command is not installed"
    echo "installing zsh-autosuggestions"
    brew install zsh-autosuggestions
    echo "source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    # git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    # source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  else  
    echo "zsh-autosuggestions command is installed"
  fi
}

# install zsh-syntax-highlighting
install_zshsyntaxhighlighting () {
  if ! command -v zsh-syntax-highlighting &> /dev/null
  then
    echo "zsh-syntax-highlighting command is not installed"
    echo "installing zsh-syntax-highlighting"
    git clone
    # git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    # source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    brew install zsh-syntax-highlighting
    echo "source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshenv
  else
    echo "zsh-syntax-highlighting command is installed"
  fi
}

# install zsh-completions
install_zshcompletions () {
  if ! command -v zsh-completions &> /dev/null
  then
    echo "zsh-completions command is not installed"
    echo "installing zsh-completions"
    # git clone
  else
    echo "zsh-completions command is installed"
  fi
}

# install zsh-history-substring-search
install_zshhistorysubstringsearch () {
  if ! command -v zsh-history-substring-search &> /dev/null
  then
    echo "zsh-history-substring-search command is not installed"
    echo "installing zsh-history-substring-search"
    # git clone
  else
    echo "zsh-history-substring-search command is installed"
  fi
}

main () {
  install_brew
  install_git
  install_warp
  install_fig
  install_iterm2
  install_vscode
  install_ohmyzsh
  install_zshautosuggestions
  install_zshsyntaxhighlighting
  install_zshcompletions
  # install_zshhistorysubstringsearch
  
  
  
}

main