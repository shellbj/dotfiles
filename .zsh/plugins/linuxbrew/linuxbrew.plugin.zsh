if [[ "${OSTYPE}" != linux* ]]; then
    print "Platform ${OSTYPE} not supported" >&2
    return 1;
fi

linuxbrewdirs=("/home/linuxbrew/.linuxbrew" "$HOME/.linuxbrew")

FOUND_LINUXBREW=0
for linuxbrewdir in $linuxbrewdirs; do
    if [[ -d "${linuxbrewdir}/bin" ]]; then
        FOUND_LINUXBREW=1
        break
    fi
done

if [[ $FOUND_LINUXBREW -eq 0 ]]; then
    if (( $+commands[brew] )) && linuxbrewdir="$(brew --prefix)"; then
        [[ -d "${linuxbrewdir}/bin" ]] && FOUND_LINUXBREW=1
    fi
fi

if [[ $FOUND_LINUXBREW -eq 1 ]]; then
    export PATH="${linuxbrewdir}/bin:${PATH}"
    export PATH="${linuxbrewdir}/sbin:${PATH}"
    export MANPATH="${linuxbrewdir}/share/man:${MANPATH}"
    export INFOPATH="${linuxbrewdir}/share/info:${INFOPATH}"
    export XDG_DATA_DIRS="${linuxbrewdir}/share:$XDG_DATA_DIRS"
    fpath=("${linuxbrewdir}/share/zsh/site-functions" $fpath)
fi

unset linuxbrewdir linuxbrewdirs FOUND_LINUXBREW
