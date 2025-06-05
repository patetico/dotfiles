#!/bin/zsh

# == Configuration ==============================
HISTFILE="${ZDOTDIR:-$HOME}/.zhistory"
HISTSIZE=50000
SAVEHIST=10000

setopt auto_pushd             # add path to history everytime user calls cd
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# == History wrapper (modified from ohmyzh) =====
function history {
  local clear list stamp="-i" REPLY
  zparseopts -E -D -K c=clear l=list f=stamp E=stamp i=stamp t:=stamp

  if [[ -n "$clear" ]]; then
    # delete history if -c is provided

    print -nu2 "This action will irreversibly delete your command history. Are you sure? [y/N] "
    builtin read -E
    [[ "$REPLY" == [yY] ]] || return 0

    print -nu2 >|"$HISTFILE"
    fc -p "$HISTFILE"

    print -u2 History file deleted.
  elif [[ $# -eq 0 ]]; then
    # show full history if no arguments provided
    builtin fc $stamp -l 1
  else
    # run `fc -l` with a custom format
    builtin fc $stamp -l "$@"
  fi
}

function history_stats() {
  local -a data footer
  local awk_cmd

  awk_cmd='
    function cmp_num_desc(i1, v1, i2, v2) { return (v2 - v1); }

    BEGIN {
        delete count[0]
    }

    {
      cmd = ($1 != "sudo") ? $1 : $2;
      if (cmd !~ /.\//) count[cmd]++;
    }

    END {
      # history size and unique commands
      printf "%d %d\n", NR, length(count);

      PROCINFO["sorted_in"] = "cmp_num_desc"
      for (cmd in count) {
        if (++pos > limit) break;
        printf "%d %d %.2f%% %s\n", pos, count[cmd], count[cmd]*100/NR, cmd;
      }
    }'

  data=("${(@f)$(builtin fc -nl 1 | awk -v limit="${1:-20}" "$awk_cmd")}")
  footer=(${(s: :)data[1]})
  shift data

  column -t -N ' ,qty,perc,command' -R '1,2,3' <<<${(pj:\n:)data}
  echo "---"
  echo "# history entries: ${footer[1]}"
  echo "# unique commands: ${footer[2]}"
}

