autoload -Uz add-zsh-hook

setopt prompt_percent
setopt prompt_subst
unsetopt transient_rprompt

function theme_standard_precmd {
    psvar=()
    vcs_info
    if [[ "$USER" != "$DEFAULT_USER" ]]; then
        psvar[1]="$USER"
    fi

    if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
        psvar[2]="@${SSH_CLIENT}"
    fi

    if [[ -n $vcs_info_msg_0_ ]]; then
        psvar[3]=$vcs_info_msg_0_
    fi

    if [[ -x $HOME/.rvm/bin/rvm-prompt ]]; then
        psvar[4]=$($HOME/.rvm/bin/rvm-prompt 2>/dev/null)
    fi

    if [[ -n $VIRTUAL_ENV ]]; then
        psvar[9]=$(basename "$VIRTUAL_ENV")
    fi
}
add-zsh-hook precmd theme_standard_precmd

function theme_standard_setup {
    if [[ "${terminfo[colors]}" -ge 8 ]]; then
        autoload colors && colors
    fi

    local dec="%{%k%f%b%K{black}%F{cyan}%}"
    local info="%{%B%F{blue}%}"
    local warn="%{%B%F{yellow}%}"
    local error="%{%B%F{red}%}"

    zstyle ':vcs_info:*' actionformats "%{${(%)info}%}%s%{${(%)dec}%}:%{${(%)info}%}%b%{${(%)dec}%}|%{${(%)error}%}%a %{${(%)warn}%}%c%{${(%)dec}%}%{${(%)error}%}%u%{${(%)dec}%}%{${(%)error}%}%m%{${(%)dec}%}"
    zstyle ':vcs_info:*' formats "%{${(%)info}%}%s%{${(%)dec}%}:%{${(%)info}%}%b%{${(%)dec}%}%{${(%)warn}%}%c%{${(%)dec}%}%{${(%)error}%}%u%{${(%)dec}%}%{${(%)error}%}%m%{${(%)dec}%}"
    zstyle ':vcs_info:*' stagedstr 'Ⓐ '
    zstyle ':vcs_info:*' unstagedstr 'Ⓜ '

    local info_line="%(?..${error}✘%?${dec} )" # return status
    info_line+="%(1j.${error}⚙${dec} .)" # jobs
    info_line+="%(!.${error}☢${dec} .)" # privileged shell
    info_line+="%(2L.${error}↳${dec} .)" # shell level
    
    local user_host_line="%(1V.${dec}‹${error}%n${dec}@%(2V.${error}.${info})%m${dec}›.%(2V.${dec}‹${info}%n${dec}@${error}%m${dec}›.))" # user if not default

    local path_info="${dec}‹${info}%45<...<%~%<<${dec}›"

    local vcs="%(3V.${dec}‹${info}\${vcs_info_msg_0_}${dec}›.)"

    local rvm="%(4V.${dec}‹${info}%4v${dec}›.)"

    PROMPT="${user_host_line}${path_info}${rvm}${dec}%E
${info_line}%# %{${no_color}%k%f%b%}"
    RPROMPT="${vcs}%{${dec}%}"
    setopt transient_rprompt
}

theme_standard_setup
