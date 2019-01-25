_homebrew-installed() {
  type brew &> /dev/null
}

FOUND_GOENV=0
goenvdirs=("$HOME/.goenv" "/usr/local/goenv" "/opt/goenv" "/usr/local/opt/goenv")
if _homebrew-installed && goenv_homebrew_path=$(brew --prefix goenv 2> /dev/null); then
  goenvdirs=($goenv_homebrew_path "${goenvdirs[@]}")
  unset goenv_homebrew_path
fi

for goenvdir in "${goenvdirs[@]}"; do
  if [ -d $goenvdir/bin -a $FOUND_GOENV -eq 0 ]; then
    FOUND_GOENV=1
    if [[ $GOENV_ROOT == '' ]]; then
      export GOENV_ROOT=$goenvdir
    fi
    export PATH=${goenvdir}/bin:$PATH
    function goenv() {
      eval "$(command goenv init - zsh)"
      goenv "$@"
    }
  fi
done
unset goenvdir goenvdirs
