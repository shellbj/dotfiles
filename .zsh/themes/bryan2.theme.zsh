function prompt_bryan2_precmd {
    # Terminal width = width - 1 (for lineup)
    local TERMWIDTH
    ((TERMWIDTH=${COLUMNS} - 1))

    # Truncate long paths
    PR_PWDLEN=""
    local PROMPTSIZE="${#${(%):-(%n@%m:%l)-()}}"
    local PWDSIZE="${#${(%):-%~}}"
    if [[ "${PROMPTSIZE} + ${PWDSIZE}" -gt ${TERMWIDTH} ]]; then
        ((PR_PWDLEN=${TERMWIDTH} - ${PROMPTSIZE}))
    fi

    psvar=()
    [[ -n $VIRTUAL_ENV ]] && psvar[9]=$(basename "$VIRTUAL_ENV")

    vcs_info
    [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$vcs_info_msg_0_"

}

function prompt_bryan2_setup {
    if [[ "${terminfo[colors]}" -ge 8 ]]; then
        autoload colors && colors
    fi

    local nocolor="%{${terminfo[sgr0]}%}"
    local -a pcc
    pcc[1]="%{$nocolor${terminfo[bold]}$fg[${1:-green}]%}"
    pcc[2]="%{$nocolor${terminfo[bold]}$fg[${2:-green}]%}"
    pcc[3]="%{$nocolor${terminfo[bold]}$fg[${3:-green}]%}"
    pcc[4]="%{$nocolor${terminfo[bold]}$fg[${4:-white}]%}"
    pcc[5]="%{$nocolor${terminfo[bold]}$fg[${5:-red}]%}"
    pcc[6]="%{$nocolor${terminfo[bold]}$fg[${6:-yellow}]%}"
    pcc[7]="%{$nocolor${terminfo[bold]}$fg[${7:-red}]%}"

    # vcs_info
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' actionformats '%F{green}%b%f|%F{red}%a%f%c%u'
    zstyle ':vcs_info:*' formats '%F{green}%b%f%c%u'
    zstyle ':vcs_info:*' stagedstr '%F{red}●%f'
    zstyle ':vcs_info:*' unstagedstr '%F{yellow}●%f'
    zstyle ':vcs_info:*' use-prompt-escapes true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' enable bzr git

    # Terminal prompt settings
    case "${TERM}" in
        dumb) # Simple prompt for dumb terminals
            unsetopt zle
            PROMPT='%n@%m:%~%% '
            ;;
        linux)
            PROMPT="$pcc[3]%n$pcc[4]@$pcc[3]%m$pcc[4]:$pcc[6]%l$pcc[4]:$pcc[5]%~$pcc[6]%%$nocolor "
            ;;
        *)  # Main prompt
            autoload -Uz add-zsh-hook
            setopt prompt_percent
            setopt prompt_subst
            setopt transient_rprompt
            add-zsh-hook precmd prompt_bryan2_precmd

            # Try to use extended characters to look nicer
            typeset -A altchar
            set -A altchar ${(s..)terminfo[acsc]}
            local PR_SET_CHARSET="%{${terminfo[enacs]}%}"
            local PR_SHIFT_IN="%{${terminfo[smacs]}%}"
            local PR_SHIFT_OUT="%{${terminfo[rmacs]}%}"
            local PR_HBAR="${altchar[q]:--}"
            local PR_LRCORNER="${altchar[j]:--}"
            local PR_URCORNER="${altchar[k]:--}"
            local PR_ULCORNER="${altchar[l]:--}"
            local PR_LLCORNER="${altchar[m]:--}"

            local ulbox="$pcc[1]$PR_SHIFT_IN$PR_ULCORNER$PR_SHIFT_OUT"
            local llbox="$pcc[1]$PR_SHIFT_IN$PR_LLCORNER$PR_SHIFT_OUT"
            local urbox="$pcc[1]$PR_SHIFT_IN$PR_URCORNER$PR_SHIFT_OUT"
            local lrbox="$pcc[1]$PR_SHIFT_IN$PR_LRCORNER$PR_SHIFT_OUT"
            local bar="$pcc[1]$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT"
   	    local lparen="$pcc[2]("
   	    local rparen="$pcc[2])"

            local user="$pcc[3]%(!.%SROOT%s.%n)$pcc[4]@$pcc[3]%m"
            local hist="$pcc[4]:$pcc[6]%l"
            local _pth='%$PR_PWDLEN<...<%~%<<'
            local pth="$pcc[5]$_pth"
            local rstat="%(!.$pcc[7].$pcc[6])%!$pcc[4]:%(?..$pcc[7]%?$pcc[4]:)%(!.$pcc[7].$pcc[6])%#"
            local vcs="%(1V.$lparen$pcc[3]\$psvar[1]$rparen.)"
            local virtualenv="%(9V.$lparen$pcc[4]env:$pcc[3]\$psvar[9]$rparen%(9V.%(1V.$bar.).).)"
            
            local lineone="$PR_SET_CHARSET$ulbox$lparen$user$hist$rparen$bar$lparen$pth$rparen"
            local linetwo="$llbox$lparen$rstat$rparen "

            local rline="$virtualenv$vcs"


            PS1="$lineone
$linetwo$nocolor"
            RPS1="$rline$nocolor"
            ;;
    esac
}

prompt_bryan2_setup "$@"
