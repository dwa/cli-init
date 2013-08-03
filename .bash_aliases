## -*- sh -*-
alias temperature='cat /proc/acpi/thermal_zone/THRM/temperature'

## gentoo
alias efetch_progress='tail -f /var/log/emerge-fetch.log'
alias bugz='bugz --skip-auth'

alias randr_dual_right='xrandr --output DFP1 --auto --right-of LCD'

alias proxyhome='curl --data "parentProxy=" "localhost:8123/polipo/config?"'
alias proxywork='curl --data "parentProxy=WORKPROXY:8080" "localhost:8123/polipo/config?"'


export ALTERNATE_EDITOR=""
export EDITOR="/usr/bin/emacsclient"
export VISUAL="/usr/bin/emacsclient"

export PATH=${HOME}/bin:${PATH}
export INFOPATH=${HOME}/info:${INFOPATH}


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
