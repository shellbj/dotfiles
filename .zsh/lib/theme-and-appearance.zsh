# colors
autoload -U colors
colors

unsetopt list_beep
setopt list_packed
setopt multios
unsetopt beep

if [[ x$WINDOW != x ]]
then
    SCREEN_NO="%B$WINDOW%b "
else
    SCREEN_NO=""
fi

# Apply theming defaults
PS1="%n@%m:%~%# "

# Setup the prompt with pretty colors
setopt prompt_subst
setopt transient_rprompt
setopt extended_glob


