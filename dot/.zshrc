# wget -O ~/.zshrc https://raw.githubusercontent.com/amitkarpe/setup/main/dot/.zshrc
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# If you come from bash you might have to change your $PATH.
export PATH=${HOME}/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"




plugins=(
aws
fzf
copyfile
copybuffer
copypath
dirhistory
aliases
alias-finder
tmux
git
docker
history-substring-search
colored-man-pages
zsh-completions
zsh-autosuggestions
zsh-syntax-highlighting
kubectl
history
kube-ps1
)

[[ ! -f ${HOME}/.oh-my-zsh/oh-my-zsh.sh ]] || source ${HOME}/.oh-my-zsh/oh-my-zsh.sh

[[ ! -f ${HOME}/.oh-my-zsh/zsh-linux.sh ]] || source ${HOME}/.oh-my-zsh/zsh-linux.sh

[[ ! -f ${HOME}/.zshrc_extra ]] || source ${HOME}/.zshrc_extra

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $HOME/.oh-my-zsh/custom/plugins/fzf-tab-completion/zsh/fzf-zsh-completion.sh
zstyle ':completion:*' fzf-search-display true
bindkey '^I' fzf_completion

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment

# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
