# -*- zsh -*-
# Lines configured by zsh-newuser-install

if [[ -z $HISTFILE ]]; then
    HISTFILE=~/.histfile
fi

HISTSIZE=5000
SAVEHIST=5000
setopt appendhistory
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dwa/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias grep='grep --colour=auto'
alias ls='ls --color=auto'

alias temperature='cat /proc/acpi/thermal_zone/THRM/temperature'
alias efetch_progress='tail -f /var/log/emerge-fetch.log'
#alias randr_dual_right='xrandr --output DFP1 --auto --right-of LCD'

alias randr_dual_right='xrandr --output DFP1 --auto --right-of LVDS'
alias randr_dual_left='xrandr --output DFP1 --auto --left-of LVDS'

alias hgpullupdate='hg pull && hg update'

alias dpms='xset dpms force off'

alias ll='ls -rtlh'

alias bugz='bugz --skip-auth'

export PATH=$HOME/bin:$PATH
export INFOPATH=~/info:${INFOPATH}

export ALTERNATE_EDITOR=""
export EDITOR="/usr/bin/emacsclient"
export VISUAL="/usr/bin/emacsclient"

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/devel
source /usr/bin/virtualenvwrapper.sh

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

setopt prompt_subst
setopt hist_ignore_space

#export PKCS11SPY=/usr/lib/opensc-pkcs11.so
#export PKCS11SPY_OUTPUT=/tmp/pkcs-spy.log


CLJ_VERSION="1.1"
CP_CLJ="/usr/share/clojure-${CLJ_VERSION}/lib/clojure.jar:/usr/share/clojure-contrib-${CLJ_VERSION}/lib/clojure-contrib.jar"
CP_NG="/usr/share/nailgun/lib/nailgun.jar"
CLASSPATH="${CP_NG}:${CP_CLJ}:."

export CLASSPATH="$(find ~/.clojure -mindepth 1 -maxdepth 1 -type d -printf '%p:' -or -iname '*.jar' -printf '%p:')${CLASSPATH}"

#find ~/.m2/repository -follow -mindepth 1 -iname '*.jar' -print0 2> /dev/null | tr \\0 \:

## will this work?
#ELISP="(setenv \"SSH_AUTH_SOCK\" \"${SSH_AUTH_SOCK}\")"
#ELISP="(progn (setenv \"SSH_AGENT_PID\" \"${SSH_AGENT_PID}\") (setenv \"SSH_AUTH_SOCK\" \"${SSH_AUTH_SOCK}\"))"

#emacsclient -e ${ELISP} > /dev/null

###
# See if we can use colors.

#autoload colors zsh/terminfo
autoload colors
zmodload zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi

# local blue_op="%{$fg[blue]%}[%{$reset_color%}"
# local blue_cp="%{$fg[blue]%}]%{$reset_color%}"
# #local path_p="${blue_op}%~${blue_cp}"
# local path_p="%{$fg[blue]%}[%~%{$reset_color%}]"
# #local user_host="${blue_op}%n@%m${blue_cp}"
# local user_host="%{$fg[gold]%}%n@%m%{$reset_color%}"
# local ret_status="${blue_op}%?${blue_cp}"
# local hist_no="${blue_op}%h${blue_cp}"
# local smiley="%(?,%{$fg[green]%}:%)%{$reset_color%},%{$fg[red]%}:(%{$reset_color%})"
# PROMPT="╭${path_p}─${user_host}─${ret_status}
# ╰${blue_op}${smiley}${blue_cp} $ "
# local cur_cmd="${blue_op}%_${blue_cp}"
# PROMPT2="${cur_cmd}> "

# My ZSH prompt theme to match the 88_madcows.theme for Irssi
# Author: Aaron Toponce
# License: Public Domain
function precmd {
    # let's get the current get branch that we are under
    # ripped from /etc/bash_completion.d/git from the git devs
    git_ps1 () {
        if which git > /dev/null; then
            local g="$(git rev-parse --git-dir 2>/dev/null)"
            if [ -n "$g" ]; then
                local r
                local b
                if [ -d "$g/rebase-apply" ]; then
                    if test -f "$g/rebase-apply/rebasing"; then
                        r="|REBASE"
                    elif test -f "$g/rebase-apply/applying"; then
                        r="|AM"
                    else
                        r="|AM/REBASE"
                    fi
                    b="$(git symbolic-ref HEAD 2>/dev/null)"
                elif [ -f "$g/rebase-merge/interactive" ]; then
                    r="|REBASE-i"
                    b="$(cat "$g/rebase-merge/head-name")"
                elif [ -d "$g/rebase-merge" ]; then
                    r="|REBASE-m"
                    b="$(cat "$g/rebase-merge/head-name")"
                elif [ -f "$g/MERGE_HEAD" ]; then
                    r="|MERGING"
                    b="$(git symbolic-ref HEAD 2>/dev/null)"
                else
                    if [ -f "$g/BISECT_LOG" ]; then
                        r="|BISECTING"
                    fi
                    if ! b="$(git symbolic-ref HEAD 2>/dev/null)"; then
                       if ! b="$(git describe --exact-match HEAD 2>/dev/null)"; then
                          b="$(cut -c1-7 "$g/HEAD")..."
                       fi
                    fi
                fi
                if [ -n "$1" ]; then
                     printf "$1" "${b##refs/heads/}$r"
                else
                     printf "%s" "${b##refs/heads/}$r"
                fi
            fi
        else
            printf ""
        fi
    }

    GITBRANCH="$(git_ps1)"

    # The following 9 lines of code comes directly from Phil!'s ZSH prompt
    # http://aperiodic.net/phil/prompt/
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))

    local PROMPTSIZE=${#${(%):--- %D{%R.%S %a %b %d %Y}\! }}
    local PWDSIZE=${#${(%):-%~}}

    if [[ "$PROMPTSIZE + $PWDSIZE" -gt $TERMWIDTH ]]; then
	(( PR_PWDLEN = $TERMWIDTH - $PROMPTSIZE ))
    fi

    # set a simple variable to show when in screen
    if [[ -n "${WINDOW}" ]]; then
        SCREEN=" S:${WINDOW}"
    else
        SCREEN=""
    fi

    # check if jobs are executing
    if [[ $(jobs | wc -l) -gt 0 ]]; then
        JOBS=" J:%j"
    else
        JOBS=""
    fi

    # I want to know my battery percentage when running on battery power
    if which ibam &> /dev/null; then
        BATTSTATE="$(ibam --percentbattery)"
        BATTPRCNT="${BATTSTATE[(f)1][(w)-2]}"
        BATTTIME="${BATTSTATE[(f)2][(w)-1]}"
        PR_BATTERY=" B:${BATTPRCNT}%% (${BATTTIME})"
        if [[ "${BATTPRCNT}" -lt 15 ]]; then
            PR_BATTERY="${PR_BRIGHT_RED}${PR_BATTERY}"
        elif [[ "${BATTPRCNT}" -lt 50 ]]; then
            PR_BATTERY="${PR_BRIGHT_YELLOW}${PR_BATTERY}"
        elif [[ "${BATTPRCNT}" -lt 100 ]]; then
            PR_BATTERY="${PR_RESET}${PR_BATTERY}"
        else
            PR_BATTERY=""
        fi
    fi
}

setprompt () {
    # Need this, so the prompt will work
    setopt prompt_subst

    # let's load colors into our environment, then set them
    autoload colors zsh/terminfo

    if [[ "$terminfo[colors]" -gt 8 ]]; then
        colors
    fi

    for COLOR in RED GREEN YELLOW WHITE BLACK BLUE MAGENTA; do
        eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
        eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
    done

    PR_RESET="%{$reset_color%}"

    # Finally, let's set the prompt
    PROMPT='\
${PR_BRIGHT_BLACK}<${PR_RESET}${PR_RED}<${PR_BRIGHT_RED}<${PR_RESET} \
${PR_BRIGHT_YELLOW}%n@%m${PR_RESET}${PR_RED}!${PR_RESET}${PR_BRIGHT_BLUE}%$PR_PWDLEN<...<%~%<<${PR_RESET}${PR_RED}!${PR_RESET}<${PR_MAGENTA}${GITBRANCH}${PR_RESET}>${PR_RED}!${PR_RESET}${JOBS}%(?.. E:%?)\

${PR_BRIGHT_BLACK}>${PR_RESET}${PR_GREEN}>${PR_BRIGHT_GREEN}>\
${PR_BRIGHT_BLACK}${PR_RESET} '
#     PROMPT='\
# ${PR_BRIGHT_BLACK}<${PR_RESET}${PR_RED}<${PR_BRIGHT_RED}<${PR_RESET} \
# %D{%R.%S %a %b %d %Y}${PR_RED}!${PR_RESET}%$PR_PWDLEN<...<%~%<< \

# ${PR_BRIGHT_BLACK}<${PR_RESET}${PR_RED}<${PR_BRIGHT_RED}<\
# ${PR_RESET} %n@%m${PR_RED}!${PR_RESET}H:%h${SCREEN}${JOBS}%(?.. E:%?)\
# ${PR_BATTERY}${GITBRANCH}\

# ${PR_BRIGHT_BLACK}>${PR_RESET}${PR_GREEN}>${PR_BRIGHT_GREEN}>\
# ${PR_BRIGHT_BLACK}${PR_RESET} '

    # Of course we need a matching continuation prompt
    PROMPT2='\
${PR_BRIGHT_BLACK}>${PR_RESET}${PR_GREEN}>${PR_BRIGHT_GREEN}>\
${PR_RESET} %_ ${PR_BRIGHT_BLACK}>${PR_RESET}${PR_GREEN}>\
${PR_BRIGHT_GREEN}>${PR_BRIGHT_BLACK}${PR_RESET} '
}

setprompt

# get globbing for scp the way BASH does it:
setopt no_nomatch


#setopt extendedglob
#zmodload -a colors
#zmodload -a autocomplete
#zmodload -a complist


zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors 'reply=( "=(#b)(*$VAR)(?)*=00=$color[green]=$color[bg-green]" )'
zstyle ':completion:*:*:*:*:hosts' list-colors '=*=34;49'
zstyle ':completion:*:*:*:*:users' list-colors '=*=31;49'
#zstyle ':completion:*' list-colors
