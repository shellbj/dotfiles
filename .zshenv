zenv_dir=${HOME}/.zsh/env

# defaults
if [ -f ${zenv_dir}/zshenv.zsh ]; then
    . ${zenv_dir}/zshenv.zsh
fi

HOSTNAME=`hostname`
# environment specifics
if [ -f ${zenv_dir}/${HOSTNAME}/zshenv.zsh ]; then
    . ${zenv_dir}/${HOSTNAME}/zshenv.zsh
fi
