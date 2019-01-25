## jenv based on rbenv; not the rvm clone with the same name
## https://github.com/gcuisinier/jenv
## http://www.jenv.be

_homebrew-installed() {
  type brew &> /dev/null
}

FOUND_JENV=0
jenvdirs=("$HOME/.jenv" "/usr/local/jenv" "/opt/jenv" "/usr/local/opt/jenv")
if _homebrew-installed && jenv_homebrew_path=$(brew --prefix jenv 2>/dev/null); then
    jenvdirs=($jenv_homebrew_path "${jenvdirs[@]}")
    unset jenv_homebrew_path
fi

for jenvdir in "${jenvdirs[@]}" ; do
  if [ -d $jenvdir/bin -a $FOUND_JENV -eq 0 ] ; then
    FOUND_JENV=1
    if [[ $JENV_ROOT = '' ]]; then
      JENV_ROOT=$jenvdir
    fi
    export JENV_ROOT
    export PATH=${jenvdir}/bin:$PATH

    function jenv() {
        eval "$(command jenv init --no-rehash - zsh)"

        function jenv_prompt_info() {
            echo "$(jenv version-name)"
        }
        jenv "$@"
    }
  fi
done
unset jenvdir jenvdirs

if [ $FOUND_JENV -eq 0 ] ; then
  function jenv_prompt_info() { echo "system: $(java -version 2>&1 | cut -f 3 -d ' '|cut -f 2 -d '"'|head -n1)" }
fi
