#!/bin/bash
#super awesome capslock key
setxkbmap -option 'caps:ctrl_modifier'
host_name=`hostname -s`
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")

function demonize {
    pid="/tmp/__$1.pid"
    # if no pid file or no process
    if [ ! -f "$pid" ] || ! kill -0 `cat $pid` 2>/dev/null; then
        $2 > /dev/null 2>&1 &
        echo $! > $pid
    fi
}

# make use of the useless capslock
killall xcape -9 > /dev/null 2>&1
xcape -e 'Caps_Lock=Escape'

# daemons
anamnesis --start > /dev/null 2>&1
insync start > /dev/null 2>&1
compton -b
demonize redshift 'redshift-gtk'
demonize textaid "perl $scriptpath/edit-server.pl"
demonize mopidy mopidy
demonize rescuetime rescuetime
demonize nm-applet nm-applet

# sepcific for the computer
if [ "$host_name" == "darkbox" ]; then # pc at work
    demonize davmail davmail
fi
