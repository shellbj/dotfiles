_homebrew-installed() {
  type brew &> /dev/null
}

FOUND_NODENV=0
nodenvdirs=("$HOME/.nodenv" "/usr/local/nodenv" "/opt/nodenv" "/usr/local/opt/nodenv")
if _homebrew-installed && nodenv_homebrew_path=$(brew --prefix nodenv 2>/dev/null); then
    nodenvdirs=($nodenv_homebrew_path "${nodenvdirs[@]}")
    unset nodenv_homebrew_path
fi

for nodenvdir in "${nodenvdirs[@]}" ; do
  if [ -d $nodenvdir/bin -a $FOUND_NODENV -eq 0 ] ; then
    FOUND_NODENV=1
    if [[ $NODENV_ROOT = '' ]]; then
        export NODENV_ROOT=$nodenvdir
    fi
    export PATH=${nodenvdir}/bin:$PATH
    eval "$(nodenv init - zsh)"
  fi
done
unset nodenvdir
