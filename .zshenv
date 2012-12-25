# Path to your the configuration.
ZSH=$HOME/.zsh

# defaults
if [ -f ${ZSH}/env/zshenv.zsh ]; then
    source ${ZSH}/env/zshenv.zsh
fi

# environment specifics
if [ -f ${ZSH}/env/$(hostname)/zshenv.zsh ]; then
    source ${ZSH}/env/$(hostname)/zshenv.zsh
fi
