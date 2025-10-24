#!/bin/zsh

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .2='../..'
alias -g .3='../../..'
alias -g .4='../../../..'
alias -g .5='../../../../..'

alias d='dirs -v'

alias -- -='cd -'

# directory stack
for index in $(seq 1 9); do alias "$index"="cd +${index}"; done
unset index

alias md='mkdir -p'
alias rd=rmdir

alias ls='ls --color=auto --group-directories-first'
alias l='ls -lahF'

alias grep='grep -Pi --color=auto'

alias dkr='docker'
alias dkrx='docker run --rm'
alias dkrxu='docker run --rm -u $(id -u):$(id -g)'
alias dkrps="docker ps -a --format 'table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}'"

alias dco='docker compose'
alias dcou='docker compose up -d'
alias dcod='docker compose down'
alias dcop='docker compose pull'

alias ldocker='lazydocker'
alias ldkr='lazydocker'
alias lgit='lazygit'

alias cz='chezmoi'
alias y='yazi'

alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
