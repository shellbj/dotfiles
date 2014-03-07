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
        psvar[3]=$vcs_info_msg_1_
        psvar[4]=${${vcs_info_msg_2_%/${~vcs_info_msg_3_}}/${HOME}/\~}
        psvar[5]="$vcs_info_msg_3_ $vcs_info_msg_4_"
    fi

    psvar[7]=""
    local PROMPTSIZE="${#${(%):-%(1V.<%1v%2v>.)<>%(3V.<%3v>.)}}"
    local PWDSIZE="${#${(%):-%(3V.%4v %5v.%~)}}"
    if [[ "${PROMPTSIZE} + ${PWDSIZE}" -gt ${COLUMNS} ]]; then
        ((psvar[7]=${COLUMNS} - ${PROMPTSIZE}))
    fi

    if [[ -x $HOME/.rvm/bin/rvm-prompt ]]; then
        psvar[8]=$($HOME/.rvm/bin/rvm-prompt 2>/dev/null)
    fi

    if [[ -n "$RBENV_SHELL" ]]; then
        whence -w rbenv_prompt_info 2>/dev/null 1>/dev/null
        if [[ $? -eq 0 ]]; then
            psvar[8]=$(rbenv_prompt_info 2>/dev/null)
        fi
    fi

    if [[ -n $VIRTUAL_ENV ]]; then
        psvar[9]="venv:$(basename "$VIRTUAL_ENV")"
    fi

    if [[ -n "$PYENV_SHELL" ]]; then
        whence -w rbenv_prompt_info 2>/dev/null 1>/dev/null
        if [[ $? -eq 0 ]]; then
            psvar[9]+="pyenv:$(pyenv_prompt_info 2>/dev/null)"
        fi
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

    zstyle ':vcs_info:*' actionformats "${info}%s${adorn}:${info}%b${adorn}|${error}%a ${notice}%c${warn}%u%${error}%m${reset_color}" "%s:%b|%a %c%u%%m" "%R" "%r" "%S"
    zstyle ':vcs_info:*' formats "${info}%s${adorn}:${info}%b${notice}%c${warn}%u${error}%m${reset_color}" "%s:%b%c%u%m" "%R" "%r" "%S"
    zstyle ':vcs_info:*' stagedstr "Ⓐ "
    zstyle ':vcs_info:*' unstagedstr "Ⓜ "
    zstyle ':vcs_info:*' max-exports 5

    local info_line="%(?..${error}✘${dec} )" # return status
    info_line+="%(1j.${notice}⚙${dec} .)" # jobs
    info_line+="%(!.${error}☢${dec} .)" # privileged shell
    info_line+="%(2L.${notice}↳${dec} .)" # shell level

    local user_host_line="%(1V.${dec}‹${error}%n${adorn}@%(2V.${error}.${notice})%m${dec}›.%(2V.${dec}‹${notice}%n${adorn}@${error}%m${dec}›.))" # user if not default

    local path_info="${dec}‹${info}%\${psvar[7]}<..<%(3V.%4v %5v.%~)%<<${dec}›"

    local vcs="%(3V.${dec}‹${info}\${vcs_info_msg_0_}${dec}›.)"

    local rvm="%(8V.${dec}‹${info}%8v${dec}›.)"

    local venv="%(9V.${dec}‹${info}%9v${dec}›.)"

    PROMPT="${user_host_line}${path_info}${vcs}${dec}%E
${info_line}%(!.${error}.${adorn})%#%{${reset_color}%k%f%b%} "
    RPROMPT="${rvm}${venv}%{${reset_color}%k%f%b%}"
}

theme_standard_setup
