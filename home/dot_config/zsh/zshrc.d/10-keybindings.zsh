#!/bin/zsh

# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
# check `man terminfo` for key codes https://man7.org/linux/man-pages/man5/terminfo.5.html

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  # Make sure the terminal is in application mode when zle is
  # active. Only then are the values from $terminfo valid.
	autoload -Uz add-zle-hook-widget

  function zle_application_mode_start { echoti smkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start

  function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

function __hotkey() {
  local mode key cmd load_widget

  zparseopts -D -E w=load_widget -widget=load_widget

  if [[ -n "$load_widget" ]]; then
    autoload -U "$1"
    zle -N "$1"
  fi

  cmd=$1
  shift

  for key in $@; do
    if [[ $key =~ '^\w+$' ]]; then
      key="${terminfo[$key]}"
      [[ -z "$key" ]] && continue
    fi

    for mode in emacs viins vicmd; do
      bindkey -M $mode "$key" "$cmd"
    done
  done
}

# Use emacs key bindings
bindkey -e

__hotkey up-line-or-history kpp                        # [PageUp] Up a line of history
__hotkey down-line-or-history knp                      # [PageDown] Down a line of history
__hotkey -w up-line-or-beginning-search '^[[A' kcuu1   # [Up] fuzzy find history forward
__hotkey -w down-line-or-beginning-search '^[[B' kcud1 # [Down] fuzzy find history backward
__hotkey beginning-of-line khome                       # [Home] Go to beginning of line
__hotkey end-of-line kend                              # [End] Go to end of line
__hotkey reverse-menu-complete kcbt                    # [Shift-Tab] move through the completion menu backwards
__hotkey backward-delete-char '^?'                     # [Backspace] delete backward
__hotkey kill-word '^[[3;5~'                           # [Ctrl-Delete] delete whole forward-word
__hotkey forward-word '^[[1;5C'                        # [Ctrl-RightArrow] move forward one word
__hotkey backward-word '^[[1;5D'                       # [Ctrl-LeftArrow] move backward one word
__hotkey kill-region '^[w'                             # [Alt-w] Kill from the cursor to the mark
__hotkey history-incremental-search-backward '^r'      # [Ctrl-r] Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
__hotkey magic-space ' '                               # [Space] don't do history expansion
__hotkey -w edit-command-line '^x^e'                   # [ctrl+x ctrl+e] Edit the current command line in $EDITOR
__hotkey copy-prev-shell-word '^[m'                    # [Alt-m] repeat last word

bindkey -s '\el' 'ls\n' # [Alt-l] run command: ls

# [Delete] delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  __hotkey delete-char kdch1
else
  __hotkey delete-char "^[[3~"
fi

# consider other keybindings:

#bindkey '^[^[[C' emacs-forward-word
#bindkey '^[^[[D' emacs-backward-word

#bindkey -s '^X^Z' '%-^M'
#bindkey '^[e' expand-cmd-path
#bindkey '^[^I' reverse-menu-complete
#bindkey '^X^N' accept-and-infer-next-history
#bindkey '^W' kill-region
#bindkey '^I' complete-word

## Fix weird sequence that rxvt produces
#bindkey -s '^[[Z' '\t'

unfunction __hotkey
