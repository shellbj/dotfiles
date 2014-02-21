alias alternatives='/usr/sbin/update-alternatives --admindir ~/.alternatives/admin --altdir ~/.alternatives'
compdef _update-alternatives alternatives

# alias build.sh to _ant completion
compdef _ant build.sh

DEFAULT_USER=bshell

alias fabric='bash <(curl -s "https://stash.orbitz.net/projects/CD/repos/glu-tools/browse/setup_fabric.sh?raw")'
alias oldfabric='bash <(curl -s http://git.orbitz.net/ada/glu-tools/blobs/raw/master/setup_fabric.sh)'
