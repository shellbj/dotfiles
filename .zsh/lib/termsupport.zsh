# set a formated title 
function _format_title() {
  if [[ "$DISABLE_AUTO_TITLE" == "true" ]] || [[ "$EMACS" == *term* ]]; then
    return
  fi

  case $TERM in
  screen*)
    print -Pn "\ek$1:$2\e\\"      # screen title (in ^A")
#    print -Pn "\ek$1:q\e\\" #set screen hardstatus, usually truncated at 20 chars
    ;;
  xterm*|rxvt*)
    print -Pn "\e]2;$2:q\a" #set window name
    print -Pn "\e]1;$1:q\a" #set icon (=tab) name (will override window name on broken terminal)
#    print -Pn "\e]2;$1:$2\a" # plain xterm title
#    print -Pn "\e]1;$1:q\a" #set icon (=tab) name (will override window name on broken terminal)
    ;;
  esac
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"

function _precmd_title()  {
#    title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
    _format_title "%55<..<%~%<<" "%n@%m"
}

function _preexec_title() {
#  emulate -L zsh
 # setopt extended_glob
#  local CMD=${1[(wr)^(*=*|sudo|ssh|rake|-*)]} #cmd name only, or if this is sudo or ssh, the next cmd

  # escape '%' chars in $1, make nonprintables visible
  CMD=${(V)1//\%/\%\%}
  # Truncate command, and join lines.
  CMD=$(print -Pn "%40>...>$a" | tr -d "\n")

  _format_title "$CMD" "%100>...>${2:gs/%/%%}%<<"
#  _format_title "$CMD"  "%n@%m" "%35<...<%~"
}

# add hooks
autoload -Uz add-zsh-hook
add-zsh-hook precmd _precmd_title
add-zsh-hook preexec _preexec_title
