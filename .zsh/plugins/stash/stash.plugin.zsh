FOUND_STASH=0
stashdirs=("$HOME/.stash" "/usr/local/stash" "/opt/stash")

for stashdir in "${stashdirs[@]}"; do
  if [ -d $stashdir/bin -a $FOUND_STASH -eq 0 ]; then
    FOUND_STASH=1
    export STASH_ROOT=$stashdir
    export PATH=${stashdir}/bin:$PATH
    function stash() {
      eval "$(command stash init - zsh)"
      stash "$@"
    }
  fi
done
unset stashdirs stashdir
