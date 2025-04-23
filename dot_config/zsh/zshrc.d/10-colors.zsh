#!/bin/zsh

autoload -U colors && colors

typeset -AHg FX FG BG

FX=(
  reset     "%{[00m%}"
  bold      "%{[01m%}" no-bold      "%{[22m%}"
  dim       "%{[02m%}" no-dim       "%{[22m%}"
  italic    "%{[03m%}" no-italic    "%{[23m%}"
  underline "%{[04m%}" no-underline "%{[24m%}"
  blink     "%{[05m%}" no-blink     "%{[25m%}"
  reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
  FG[$color]="%{[38;5;${color}m%}"
  BG[$color]="%{[48;5;${color}m%}"
done

function spectrum() {
  setopt localoptions nopromptsubst

  local test_str=${2:-'Lorem ipsum dolor sit amet, consectetur adipiscing elit'}
  local -A color_type

  case "${1:l}" in
  fg) set -A color_type ${(kv)FG} ;;
  bg) set -A color_type ${(kv)BG} ;;
  *)
    echo "usage: $0 (fg|bg) [text]"
    return 1
    ;;
  esac

  for code in {000..255}; do
    print -P -- "$code: ${color_type[$code]}${test_str}%{$reset_color%}"
  done
}

# Default coloring for BSD-based ls
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Default coloring for GNU-based ls
if [[ -z "$LS_COLORS" ]]; then
  # Define LS_COLORS via dircolors if available. Otherwise, set a default
  # equivalent to LSCOLORS (generated via https://geoff.greer.fm/lscolors)
  if (($+commands[dircolors])); then
    [[ -f "$HOME/.dircolors" ]] &&
      source <(dircolors -b "$HOME/.dircolors") ||
      source <(dircolors -b)
  else
    export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
  fi
fi

# set completion colors to be the same as `ls`
[[ -z "$LS_COLORS" ]] || zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"


export LESS=' -R '
export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
