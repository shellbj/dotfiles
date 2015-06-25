alias dockerrm='docker rm -v $(docker ps -a -q -f status=exited)'
alias dockerrmi='docker rmi $(docker images -q -f dangling=true)'
