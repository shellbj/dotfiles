FOUND_NODENV=0
nodenvdirs=("$HOME/.nodenv" "/usr/local/nodenv" "/opt/nodenv")

for nodenvdir in "${nodenvdirs[@]}" ; do
  if [ -d $nodenvdir/bin -a $FOUND_NODENV -eq 0 ] ; then
    FOUND_NODENV=1
    export NODENV_ROOT=$nodenvdir
    export PATH=${nodenvdir}/bin:$PATH
    eval "$(nodenv init - zsh)"
  fi
done
unset nodenvdir
