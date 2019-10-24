# Load anything managed via antibody
if [[ -e $ZSH/antibody.txt ]]; then
    if [ $+commands[antibody] ]; then
        source <(antibody init)
        antibody bundle < $ZSH/antibody.txt
    fi
fi
