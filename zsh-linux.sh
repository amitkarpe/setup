# # https://github.com/jonmosco/kube-ps1.git
# source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"
# PS1='$(kube_ps1)'$PS1
# PROMPT='$(kube_ps1)'$PROMPT
# export KUBE_PS1_SYMBOL_USE_IMG=true
# alias kctx="kubectx"
# alias kns="kubens"
alias tf="terraform"
alias tg="terragrunt"
# alias gotodev="export KUBECONFIG=~/.kube/finxflo-ap-2"
# alias gotoprod="export KUBECONFIG=~/.kube/finxflo-ap-prod"
# alias gotocicd="export KUBECONFIG=~/.kube/cicd-cluster"
# alias bedevops="aws-azure-login --no-prompt --profile devops; export AWS_PROFILE=devops; aws sts get-caller-identity"
# export k3d=i-019c7831c28d7cee3
# alias startk3d="export AWS_REGION=ap-southeast-2; aws ec2 start-instances --instance-ids $k3d"
# alias stopk3d="export AWS_REGION=ap-southeast-2; aws ec2 stop-instances --instance-ids $k3d"
# export cd1=i-0acd1e20555ed09ce
# alias startcd1="export AWS_REGION=ap-southeast-1; aws ec2 start-instances --instance-ids $cd1"
# alias stopcd1="export AWS_REGION=ap-southeast-1; aws ec2 stop-instances --instance-ids $cd1"
# alias startsel='export AWS_REGION=ap-southeast-1; aws ec2 start-instances --instance-ids i-01caa251743c06593'
# alias stopsel='export AWS_REGION=ap-southeast-1; aws ec2 stop-instances --instance-ids i-01caa251743c06593'
# source <(kubectl completion zsh)
# complete -F __start_kubectl k

# complete -C '/opt/homebrew/bin/aws_completer' aws
# #complete -o nospace -C /usr/local/bin/terraform terraform
# #complete -o nospace -C '~/bin/terraform' terraform
# #complete -C '/opt/homebrew/bin/terragrunt' terragrunt

# #complete -C aws_completer aws
# #alias aws-profile="source aws-profile"
# #alias aws="aws-wrapper"


# autoload bashcompinit && bashcompinit
# autoload -Uz compinit && compinit

# ssh-add ~/.ssh/fxf-github
# export AWS_PAGER=""
# export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# export AWS_REGION=ap-southeast-1
# export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# ulimit -n 65536 200000
# #export TERRAGRUNT_DOWNLOAD=~/TERRAGRUNT_DOWNLOAD/
# export TERRAGRUNT_DOWNLOAD=~/.terraform.d/TERRAGRUNT_DOWNLOAD/
# alias samut="export AWS_REGION=ap-south-1; export AWS_PROFILE=multi"
# alias cicd="export AWS_REGION=us-east-1; export AWS_PROFILE=cicd; export KUBECONFIG=~/.kube/cicdnew"
# export TFENV_ARCH=arm64
# export PATH="$HOME/.tfenv/bin:$PATH"
