# Path to your the configuration.
ZSH=${ZDOTDIR:-$HOME}/.zsh

# defaults
if [ -f ${ZSH}/env/zprofile.zsh ]; then
    source ${ZSH}/env/zprofile.zsh
fi

# environment specifics
if [ -f ${ZSH}/env/$(hostname)/zprofile.zsh ]; then
    source ${ZSH}/env/$(hostname)/zprofile.zsh
fi


