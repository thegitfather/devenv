alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lFh'
alias lla='ls -alFh'

# list only hidden files
alias lh='ls -d .*'
alias llh='ls -alFhd .*'

# ll with sort
alias llsort='ll -Art1 && printf "\n" && echo "### newest ###"'
alias llsort-rev='ll -At1lh && printf "\n" && echo "### oldest ###"'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias rgrep='rgrep --color=auto'

## sort for elapsed time, limit to 80 chars (no etimes output on openwrt)
alias psl='ps -eo pid,user,cmd:50,etime --sort start_time | grep -v "ps -eo" | grep -v grep'
alias pslgrep='psl | grep -i'

## remove all node_modules folders recursivly in current path
alias rmnodemodules='find . -name "node_modules" -type d -prune -exec rm -rf '{}' +'

## list all open tcp ports
alias openports='netstat -lnp |grep "tcp "'

# find biggest files
alias findbiggestfiles='find -type f -exec du -Sh {} + | sort -rh | head -n 10'

# list biggest folders
alias duhbiggestfolder='du -Sh | sort -rh | head -10'

# bash history
alias hgrep='history | grep -v hgrep | grep'

# disk space and memory
alias df='df -h'
alias free='free -h'

# copy (show progress)
alias rsync-progress='rsync -ah --progress'

# Docker
alias dstopall='docker stop $(docker ps -a -q)'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimages='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dstart='docker start'
alias dstop='docker stop'
alias dkill='docker kill'
alias dattach='docker attach'
alias dexec='docker exec'
alias dports='docker port'

# systemctl
alias systemctlu='systemctl --user'
alias sctlu='systemctl --user'
alias sctl='systemctl'

# git
alias gitresetclean='git reset --hard && git clean -df'
alias gitcheckout='git fetch && git checkout'
alias gitfetchpull='git fetch && git pull'
alias gitrebasemain='git fetch && git rebase origin/main'
alias gitrebasedevelop='git fetch && git rebase origin/develop'

# zsh reload
alias zshreload='source ~/.zshrc'

# umount sshfs as user
alias umountsshfs='fusermount -u'
