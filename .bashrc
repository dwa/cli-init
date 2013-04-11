# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
alias temperature='cat /proc/acpi/thermal_zone/THRM/temperature'
alias efetch_progress='tail -f /var/log/emerge-fetch.log'

alias randr_dual_right='xrandr --output DFP1 --auto --right-of LCD'

[[ -f /etc/profile.d/bash-completion.sh ]] && source /etc/profile.d/bash-completion.sh

export PATH=$HOME/bin:$PATH
export INFOPATH=~/info:${INFOPATH}