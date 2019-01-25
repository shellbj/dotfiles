if (($ + commands[direnv])); then
  function direnv() {
    eval "$(command direnv hook zsh)"
  }
fi
