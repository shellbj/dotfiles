if (( $+commands[direnv] )); then
  function direnv() {
    unfunction direnv
    eval "$(command direnv hook zsh)"
  }
fi
