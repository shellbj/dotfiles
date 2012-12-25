function prompt_bryan_precmd {
	local exitstatus=$?
	setopt localoptions noxtrace noksharrays
	psvar=(SIG)
	[[ $exitstatus -gt 128 ]] && psvar[1]=SIG$signals[$exitstatus-127]
	[[ $psvar[1] = SIG ]] && psvar[1]=$exitstatus
	jobs % >/dev/null 2>&1 && psvar[2]=
}

function prompt_bryan_setup {
    autoload -Uz add-zsh-hook
    setopt prompt_percent
    setopt prompt_subst
    setopt transient_rprompt

    add-zsh-hook precmd prompt_bryan_precmd

    prompt_opts=( cr subst percent )

    local text_col=${1:-'cyan'}
    local parens_col=${2:-'blue'}

    local text="%{$fg_bold[$text_col]%}"
    local parens="%{$fg_bold[$parens_col]%}"
    local punct="%{$fg_bold[grey]%}"
    local reset="%{$reset_color%}"

    local lpar="$parens($text"
    local rpar="$parens)$text"

    local user="$text%n$punct%(2v.%B@%b.@)$text%m"
    local rstat="%(?..$parens{$reset%v$parens})"
    local hist="$text%!$punct/$text%y"
    local date="$text%D{%I:%M%P}$punct:$text%D{%m/%d/%y}"
    local pth="$text%#$punct:$text%~"
    local lend="$punct-$reset"

    local lineone="$lpar$user$rpar$lpar$hist$rpar$lpar$date$rpar$rstat$lend"
    local linetwo="$lpar$pth$rpar$lend "

    PS1="$lineone
$linetwo"

    PS2="$parens$lend "
}

prompt_bryan_setup "$@"
