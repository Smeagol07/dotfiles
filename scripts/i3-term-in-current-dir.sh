#!/bin/bash
(if [[ "$1" == "--tmux" || "$1" == "-t" ]]; then
    urxvt -e zsh -ic "~/.scripts/tmuxin.sh "'"'"`xcwd`"'"'""
else
    urxvt -cd "`xcwd`"
fi) > /dev/null 2>&1 &
