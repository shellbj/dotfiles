# Path to your the configuration.
ZSH=${ZDOTDIR:-$HOME}/.zsh

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# defaults
if [ -f ${ZSH}/env/zshenv.zsh ]; then
    source ${ZSH}/env/zshenv.zsh
fi

# environment specifics
if [ -f ${ZSH}/env/$(hostname)/zshenv.zsh ]; then
    source ${ZSH}/env/$(hostname)/zshenv.zsh
fi

# private environmental specifics
if [ -f ${HOME}/.private.zsh ]; then
    source ${HOME}/.private.zsh
fi
