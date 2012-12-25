# aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir

# List direcory contents
alias ls='ls --color=auto'
alias lsa='ls -lah'
alias l='ls -lA1'
alias ll='ls -l'
alias la='ls -lA'

alias e='emacsclient -n'
alias et='emacsclient -t'

alias cless='colordiff|less -r'

if [[ -e /etc/debian_version ]]; then
    if (( EUID != 0 )); then
        alias apt-get='sudo apt-get'
        alias dpkg='sudo dpkg'
        alias dpkg-reconfigure='sudo dpkg-reconfigure'
        alias debup='sudo apt-get update && sudo apt-get upgrade'
    fi
    
    alias apt-search='apt-cache search'
fi
