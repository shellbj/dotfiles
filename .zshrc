#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

GPG_TTY=$(tty)
export GPG_TTY

if which gpg-agent >/dev/null 2>&1; then
    GPG_FILE="${HOME}/.gpg-agent.env"
    if test -f ${GPG_FILE} && kill -0 $(grep GPG_AGENT_INFO ${GPG_FILE}|cut -d: -f 2) 2>/dev/null; then
        . ${GPG_FILE}
        eval $(cut -d= -f 1 < ${GPG_FILE}|xargs echo export)
    else
        gpg-agent --write-env-file=${GPG_FILE} --daemon #--enable-ssh-support 
    fi
fi

# keybind
bindkey -e # like emacs

bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history

# Where to look for autoloaded function definitions
fpath=(~/.zsh ~/.zsh/upstream $fpath)

# completions setting
autoload -U compinit
compinit

# cache
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# color
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'

# call ant to get completion targets for only build.sh
zstyle ":completion::complete:build.sh:*:targets" call-command yes

# change word delimns
autoload -U select-word-style
select-word-style bash

# options
setopt auto_pushd
setopt pushd_to_home
setopt complete_in_word
unsetopt list_beep
setopt list_packed
setopt multios
unsetopt beep

# history
HISTFILE=$HOME/.zhistory
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history
setopt extended_history
setopt transient_rprompt

# colors
autoload -U colors
colors

# prompt
case $TERM in
    dumb)
        ;;
    *)
        autoload -U promptinit
        promptinit
        prompt bryan green blue
        ;;
esac

# JDEE project file
autoload -U makeprj

# set a formated title 
function _format_title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\ek$a:$3\e\\"      # screen title (in ^A")
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$a:$3\a" # plain xterm title
    ;;
  esac
}

function _precmd_title()  { _format_title "zsh" "$USER@%m" "%55<...<%~" }
function _preexec_title() { _format_title "$1"  "$USER@%m" "%35<...<%~" }

# add hooks
add-zsh-hook precmd _precmd_title
add-zsh-hook preexec _preexec_title
add-zsh-hook precmd vcs_info

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias ls='ls --color=auto'
alias ll='ls -l'

alias e='emacsclient -n'
alias et='emacsclient -t'

alias cless='colordiff|less -r'

function _container_stub() {
    local opt host version base name args="";
    while getopts "b:h:v:n:" opt; do
	case "$opt" in
	    (b) base=${OPTARG};;
	    (n) name=${OPTARG};;
	    (h) host=${OPTARG};;
	    (v) version=${OPTARG};;
	    (*) args+=" ${OPTARG}";;
	esac
    done
    shift $(( OPTIND - 1 ));

    if [ -z $host ]; then
	host=$1;
    fi
    if [ -z $version ]; then
	version=$2;
    fi

    if [ -x "${base}/${host}-${version}/bin/${name}" ]; then
	echo ${base}/${host}-${version}/bin/${name} $args $*;
	eval "${base}/${host}-${version}/bin/${name} $args $*";
    else
	base=`find ${base} -xdev -type f -path '*/bin/*'  -name ${name}|tail -1`;
	echo ${base} $args $*;
	${base} $args $*;
    fi
}

function start() {
    _container_stub -b "/opt/orbitz/atlas" -n "start.py" $*;
}
function stop() {
    _container_stub -b "/opt/orbitz/atlas" -n "stop.py" $*;
}
function status() {
    _container_stub -b "/opt/orbitz/atlas" -n "status.py" $*;
}

function jstart() {
    _container_stub -b "/opt/orbitz/jboss" -n "start.py" $*;
}
function jstop() {
    _container_stub -b "/opt/orbitz/jboss" -n "stop.py" $*;
}
function jstatus() {
    _container_stub -b "/opt/orbitz/jboss" -n "status.py" $*;
}

function copy-config() {
    local user hostname config sshkey force;
    while getopts "h:l:c:f:k" opt; do
	case "$opt" in
            (h) hostname=${OPTARG};;
            (l) user=${OPTARG};;
	    (c) config=${OPTARG};;
	    (f) sshkey=${OPTARG};;
            (k) force=true;;
            (*) ;; # do nothing
	esac
    done
    shift $(( OPTIND - 1 ))
    user=${user:=${USER}}
    hostname=${hostname:=$1}
    config=${config:="${HOME}/.config.tar.bz2"}
    sshkey=${sshkey:="${HOME}/.ssh/id_dsa"}

    ssh -t -q -o "BatchMode=yes" ${user}@${hostname} "echo 2>&1"
    if [[ $? -ne 0 ]]; then
        ssh-copy-id -i ${sshkey} ${user}@${hostname} > /dev/null;
        if [[ $? -ne 0 ]]; then
            echo "$(tput smso) You need to login first to create a home directory $(tput rmso)";
            ssh -t -q ${user}@${hostname};
            ssh-copy-id -i ${sshkey} ${user}@${hostname}  > /dev/null;
        fi
    fi
    ssh -q -o "BatchMode=yes" ${user}@${hostname} "cat .copy-config >/dev/null 2>&1"
    if [[ $? -ne 0 || ! -z ${force} ]]; then
        cat ${config} | ssh -q -o "BatchMode=yes" ${user}@${hostname} 'bzcat - | tar xf -'
    fi
    ssh -q -o "BatchMode=yes" ${user}@${hostname} "touch .copy-config"
}

zenv_dir=${HOME}/.zsh/env
HOSTNAME=`hostname`
# environment specifics
if [ -f ${zenv_dir}/${HOSTNAME}/zshrc.zsh ]; then
    . ${zenv_dir}/${HOSTNAME}/zshrc.zsh
fi
