# set a formated title 
function _format_title() {
  if [[ "$DISABLE_AUTO_TITLE" == "true" ]] || [[ "$EMACS" == *term* ]]; then
    return
  fi

  case $TERM in
  screen*)
    print -Pn "\ek$1:$2\e\\"      # screen title (in ^A")
    ;;
  xterm*|rxvt*)
    print -Pn "\e]2;$2:q\a" #set window name
    print -Pn "\e]1;$1:q\a" #set icon (=tab) name (will override window name on broken terminal)
    ;;
  esac
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%55<..<%~%<<" #55 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n@%m"

function _precmd_title()  {
#    title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
    _format_title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
}

function _preexec_title() {
  # escape '%' chars in $1, make nonprintables visible
  CMD=${(V)1//\%/\%\%}
  # Truncate command, and join lines.
  CMD=$(print -Pn "%40>...>$a" | tr -d "\n")

  _format_title "$CMD" "%100>...>${2:gs/%/%%}%<<"
}

# add hooks
autoload -Uz add-zsh-hook
add-zsh-hook precmd _precmd_title
add-zsh-hook preexec _preexec_title
