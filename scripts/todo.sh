#!/bin/bash
#=================================================
# name:   todo.sh
# author: Pawel Bogut <https://pbogut.me>
# date:   25/01/2019
#=================================================
_list() {
        todo list
        echo ":new"
}

selection=$(_list | tac | rofi -dmenu)
id=$(echo $selection | sed 's/\[.\][[:space:]]*\([[:digit:]]*\).*/\1/g')

if [[ $selection == ":new" ]]; then
        $TERMINAL -t FLOATING_WINDOW -e zsh -ic "todo new"
elif [[ -n $id ]]; then
        $TERMINAL -t FLOATING_WINDOW -e zsh -ic "todo edit $id"
fi
