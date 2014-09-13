## -*- sh -*-
alias temperature='cat /proc/acpi/thermal_zone/THRM/temperature'

## gentoo
alias efetch_progress='tail -f /var/log/emerge-fetch.log'
alias bugz='bugz --skip-auth'

alias randr_dual_right='xrandr --output DFP1 --auto --right-of LCD'

alias proxyhome='curl --data "parentProxy=" "localhost:8123/polipo/config?"'
alias proxywork='curl --data "parentProxy=WORKPROXY:8080" "localhost:8123/polipo/config?"'

alias ll='ls -rtlhF'

export ALTERNATE_EDITOR=""
export EDITOR="/usr/bin/emacsclient -t"
export VISUAL="/usr/bin/emacsclient -t"

export PATH=${HOME}/bin:${PATH}
export INFOPATH=${HOME}/info:${INFOPATH}


#export PYTHONSTARTUP="$(python -m jedi repl)"
export PYTHONPATH=${PYTHONPATH}:~/.pythonstuff/

export PIP_PYPI_INDEX=https://pypi.python.org/simple/


## http://matlads.blogspot.se/2012/09/tweaking-psql-in-color.html#gpluscomments
psql() {
    YELLOW=$(printf "\e[1;33m" )
    LIGHT_CYAN=$(printf "\e[1;36m" )
    NOCOLOR=$(printf "\e[0m" )

    export LESS="-iMSx4 -FXR"

    PAGER="sed \"s/\([[:space:]]\+[0-9.\-]\+\)$/${LIGHT_CYAN}\1$NOCOLOR/;"
    PAGER+="s/\([[:space:]]\+[0-9.\-]\+[[:space:]]\)/${LIGHT_CYAN}\1$NOCOLOR/g;"
    PAGER+="s/|/$YELLOW|$NOCOLOR/g;s/^\([-+]\+\)/$YELLOW\1$NOCOLOR/\" 2>/dev/null  | less"
    export PAGER

    env psql "$@"
    unset LESS PAGER
}

## based on:
## http://raim.codingfarm.de/blog/2013/01/30/tmux-update-environment/
function tmux_update_env() {
    local v
    while read v; do
        if [[ $v == -* ]]; then
            unset ${v/#-/}
        else
#           case $(expr $v : "\(.*\)=.*") in
#               DISPLAY|SSH_ASKPASS|SSH_AUTH_SOCK|SSH_AGENT_PID|SSH_CONNECTION|WINDOWID|XAUTHORITY)
            # Add quotes around the argument
            v=${v/=/=\"}
            v=${v/%/\"}
            eval export $v
#                   ;;
#           esac
        fi
    done < <(tmux show-environment)
}

eval "$(pip completion --bash)"
