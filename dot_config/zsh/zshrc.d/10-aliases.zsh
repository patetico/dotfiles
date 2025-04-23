#!/bin/zsh

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias d='dirs -v'

alias -- -='cd -'

# directory stack
for index in $(seq 1 9); do alias "$index"="cd -${index}"; done
unset index

alias md='mkdir -p'
alias rd=rmdir

alias ls='ls --color=auto --group-directories-first'
alias l='ls -lahF'

alias grep="grep -Pi --color=auto"

alias dockx="docker run --rm"
alias dockxu='docker run --rm -u $(id -u):$(id -g)'
alias dockps="docker ps -a --format 'table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}'"
