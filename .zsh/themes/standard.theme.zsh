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

    psvar[8]=""
    local TERMWIDTH
    local PROMPTSIZE="${#${(%):-(%1v%2v)(%3v)}}"
    local PWDSIZE="${#${(%):-%~}}"
    ((TERMWIDTH=${COLUMNS}-1))
    if [[ "${PROMPTSIZE} + ${PWDSIZE}" -gt ${TERMWIDTH} ]]; then
        ((psvar[8]=${TERMWIDTH} - ${PROMPTSIZE}))
    fi
}

function theme_standard_setup {
    if [[ "${terminfo[colors]}" -ge 8 ]]; then
        autoload colors && colors
    fi

    autoload -Uz add-zsh-hook
    add-zsh-hook precmd theme_standard_precmd

    setopt prompt_percent
    setopt prompt_subst
    setopt transient_rprompt

    local dec="%{%k%f%b%K{black}%F{cyan}%}"
    local info="%{%B%F{blue}%}"
    local adorn="%{%B%F{white}%}"
    local notice="%{%B%F{green}%}"
    local warn="%{%B%F{yellow}%}"
    local error="%{%B%F{red}%}"

    zstyle ':vcs_info:*' actionformats "${info}%s${adorn}:${info}%b${adorn}|${error}%a %c%u%${error}%m"
    zstyle ':vcs_info:*' formats "${info}%s${adorn}:${info}%b%c%u${error}%m"
    zstyle ':vcs_info:*' stagedstr "${notice}Ⓐ${dec} "
    zstyle ':vcs_info:*' unstagedstr "${warn}Ⓜ${dec} "

    local info_line="%(?..${error}✘${dec} )" # return status
    info_line+="%(1j.${notice}⚙${dec} .)" # jobs
    info_line+="%(!.${error}☢${dec} .)" # privileged shell
    info_line+="%(2L.${notice}↳${dec} .)" # shell level
    
    local user_host_line="%(1V.${dec}‹${error}%n${adorn}@%(2V.${error}.${notice})%m${dec}›.%(2V.${dec}‹${notice}%n${adorn}@${error}%m${dec}›.))" # user if not default

    local path_info="${dec}‹${info}%\${psvar[8]}<..<%~%<<${dec}›"

    local vcs="%(3V.${dec}‹${info}\${vcs_info_msg_0_}${dec}›.)"

    local rvm="%(4V.${dec}‹${info}%4v${dec}›.)"

    PROMPT="${user_host_line}${path_info}${vcs}${dec}%E
${info_line}%(!.${error}.${adorn})%#%{${no_color}%k%f%b%} "
    RPROMPT="${rvm}%{${no_color}%k%f%b%}"
}

theme_standard_setup
