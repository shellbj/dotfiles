if [[ -s "$HOME/.rvm/scripts/rvm" && -s "$HOME/.rvm/bin" ]]; then
    source "$HOME/.rvm/scripts/rvm"
    PATH=$PATH:$HOME/.rvm/bin

    fpath=($rvm_path/scripts/zsh/Completion $fpath)

    function _rvm_completion {
        source $rvm_path"/scripts/zsh/Completion/_rvm"
    }

    compdef _rvm_completion rvm
fi

