GPG_TTY=$(tty)
export GPG_TTY

if which gpg-agent >/dev/null 2>&1; then
    GPG_FILE="${HOME}/.gpg-agent.env"
    if test -f ${GPG_FILE} && kill -0 $(grep GPG_AGENT_INFO ${GPG_FILE}|cut -d: -f 2) 2>/dev/null; then
        . ${GPG_FILE}
        eval $(cut -d= -f 1 < ${GPG_FILE}|xargs echo export)
    else
        gpg-agent --write-env-file=${GPG_FILE} --daemon #--enable-ssh-support 
    fi
fi
