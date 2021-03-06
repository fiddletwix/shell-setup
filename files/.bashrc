#############################################################
# Suppress bash deprecation warning to use zsh
#
export BASH_SILENCE_DEPRECATION_WARNING=1

#############################################################
# Prevent multiple includes
#
if [[ -z $BASH_INCLUDED ]]; then
    export BASH_INCLUDED=yes
else
    return
fi
#############################################################

# Set our path
export PATH=/usr/local/bin:/opt/local/bin:/usr/local/sbin:/opt/local/sbin:${PATH}

# Setup for both operating systems

#############################################################
# Editor variables
#
export EDITOR=emacs
export VISUAL=emacs
#############################################################

#############################################################
# Check the windowsize after each command. If necessary,
# update the values of LINES and COLUMNS
shopt -s checkwinsize
#############################################################

#############################################################
# History control
#
_bash_history_append() {
    builtin history -a
}
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTTIMEFORMAT='%F %T '

# ignore duplicate commands and commands that start with space
export HISTCONTROL=ignoreboth

# Commands to ignore in history, delimited by ':'
HISTIGNORE='history'

# Append to history
shopt -s histappend

# force commands entered on more than one line to be a single line in history
shopt -s cmdhist
PROMPT_COMMAND="_bash_history_append; ${PROMPT_COMMAND}"
#############################################################

#############################################################
# Include iterm2 integration
#
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
#############################################################

############################################################
# Operating System Specific controls
OS=`uname -s`

#############################################################
# Mac Specific items
#
if [[ $OS == "Darwin" ]]; then
    # Use local SSH_AUTH_SOCK
    if [[ -z $SSH_AUTH_SOCK || ${SSH_AUTH_SOCK:0:7} != "/private" ]]; then
	export SSH_AUTH_SOCK=`ls /private/tmp/com.apple.launchd.*/Listeners`
    fi

    if [[ `which gsed` =~ "gsed" ]]; then
	alias sed=`which gsed`
    fi

    alias ejectall='osascript -e "tell application \"Finder\" to eject (every disk whose ejectable is true)"'
    alias ejectcd='drutil tray eject'
fi
#############################################################

#############################################################
# Linux Specific items
#
if [[ $OS == "Linux" ]]; then
  alias rm='rm -I --preserve-root'
  alias chown='chown --preserve-root'
  alias chmod='chmod --preserve-root'
  alias chgrp='chgrp --preserve-root'
fi
#############################################################

#############################################################
# Color and terminal controls
#
case "$TERM" in
    xterm*|rxvt*)
	export GREP_OPTIONS='--color=auto'
	_title_bar() {
	    printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
	}
	PROMPT_COMMAND="_title_bar; $PROMPT_COMMAND"
	PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$ '
	if [ ${OS} == "Darwin" ]; then
	    alias ls="ls -G"
	    export LSCOLORS=dxfxcxdxbxegedabagacad
	fi

	if [ ${OS} == "Linux" ]; then
	    alias ls="ls --color=auto"
	    if [ -f "$HOME/.mydircolors" ] ; then
		export LS_COLORS=`dircolors -b "$HOME/.mydircolors"`
	    fi
	fi
	;;
    *)
	PS1='\u@\h:\w \$ '
	export GREP_OPTIONS='--color=never'
	alias ls='/bin/ls --color=never'
	;;
esac

#############################################################
# Misc functions we want to predefine
#
strip_path() {
        PATH=${PATH//":$1:"/:} #delete all instances in the middle
        PATH=${PATH/%":$1"/} #delete any instance at the end
        PATH=${PATH/#"$1:"/} #delete any instance at the beginning
}

path_prepend() {
    strip_path "$1"
    if [ -d "$1" ]; then
        PATH="$1${PATH:+":$PATH"}" #prepend $1 or if $PATH is empty set to $1
    fi
}

path_append() {
    strip_path "$1"
    if [ -d "$1" ]; then
        PATH="${PATH:+"$PATH"}:$1" #prepend $1 or if $PATH is empty set to $1
    fi
}

function genmac {
   mac=$(echo $FQDN|md5|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/')
   echo $mac
}
#############################################################

#############################################################
# include bash completion

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

#############################################################
# Include system specific items

if [ -f $HOME/.bash_supplemental ]; then
    . $HOME/.bash_supplemental
fi
