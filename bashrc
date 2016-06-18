# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

use_color=false

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
        && type -P dircolors >/dev/null \
        && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
        # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
        if type -P dircolors >/dev/null ; then
                if [[ -f ~/.dir_colors ]] ; then
                        eval $(dircolors -b ~/.dir_colors)
                elif [[ -f /etc/DIR_COLORS ]] ; then
                        eval $(dircolors -b /etc/DIR_COLORS)
        else
            eval $(dircolors)
                fi
        fi

        if [[ ${EUID} == 0 ]] ; then
                PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
        else
                PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
        fi

        alias ls='ls --color=auto'
        alias grep='grep --colour=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
else
        if [[ ${EUID} == 0 ]] ; then
                # show root@ when we don't have colors
                PS1='\u@\h \W \$ '
        else
                PS1='\u@\h \w \$ '
        fi
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
    function command_not_found_handle {
            # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
           /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
           /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
        else
           printf "%s: command not found\n" "$1" >&2
           return 127
        fi
    }
fi

if [ -x /usr/bin/mint-fortune ]; then
    /usr/bin/mint-fortune
fi
alias rm='rm -Rf'
alias cp='cp -Rni'
alias and='studio &> /dev/null &'
alias ecl32='/opt/eclipse/eclipse &> /dev/null &'
export JAVA_HOME=/usr/lib/jvm/java-8-oracle/
export PATH=/usr/lib/jvm/java-8-oracle/bin/:/home/bsafwene/Downloads/android-studio/bin/:/home/bsafwene/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/bsafwene/eclipse/java-mars/eclipse/:/home/bsafwene/st/gcc-arm-none-eabi-5_2-2015q4/bin/
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export ALLJOYN_ROOT="/home/bsafwene/alljoyn/alljoyn-16.04.00-src/"
export ALLJOYN_DIST="$ALLJOYN_ROOT/core/alljoyn/build/linux/x86/debug/dist"

export CXXFLAGS="-I$ALLJOYN_DIST/cpp/inc \
		-I$ALLJOYN_DIST/about/inc \
		-I$ALLJOYN_DIST/services_common/inc \
		-I$ALLJOYN_DIST/notification/inc \
		-I$ALLJOYN_DIST/controlpanel/inc \
		-I$ALLJOYN_ROOT/services/services_common/cpp/inc/alljoyn/services_common/ \
		-I$ALLJOYN_ROOT/services/sample_apps/cpp/samples_common/"

export LDFLAGS="-L$ALLJOYN_DIST/cpp/lib \
		-L$ALLJOYN_DIST/about/lib \
		-L$ALLJOYN_DIST/services_common/lib \
		-L$ALLJOYN_DIST/notification/lib \
		-L$ALLJOYN_DIST/controlpanel/lib"

export LD_LIBRARY_PATH="$ALLJOYN_DIST/cpp/lib:$ALLJOYN_DIST/about/lib:$ALLJOYN_DIST/services_common/lib:$ALLJOYN_DIST/notification/lib:$ALLJOYN_DIST/controlpanel/lib":"/home/bsafwene/alljoyn/alljoyn-16.04.00-src/build/linux/x86_64/debug/dist/cpp/lib/"

for f in $ALLJOYN_ROOT/hackfest/aj_samples/*; do export PATH=$PATH:$f/build; done

build() {
    pushd $1
    scons WS=off
    popd
}

m() {
    if [ "$1" == "hackfest" ]; then
        for f in $ALLJOYN_ROOT/hackfest/linino/*; do build $f; done
        for f in $ALLJOYN_ROOT/hackfest/aj_samples/*; do build $f; done
    elif [ "$1" == "tutorial" ]; then
        for f in $ALLJOYN_ROOT/hackfest/tutorial/*; do build $f; done
    else
        build $ALLJOYN_ROOT/hackfest/aj_samples/$1
    fi
}
alias t="date '+%A %H:%M'"
alias py="python3"
