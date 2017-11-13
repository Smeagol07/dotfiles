#!/bin/bash
#=================================================
# name:   mpd-current-song.sh
# author: Pawel Bogut <http://pbogut.me>
# date:   09/11/2017
#=================================================
mpc="mpc -p ${MOPIDY_PORT:-6600}"
while :; do
  $mpc current \
    | sed 's/"/'"'"'/g' \
    | sed 's/\(.*\)/{"full_text": "'"`$mpc | grep paused | sed 's/.*/   /g'`"'\1"}/g'

  $mpc idleloop player \
    | while read x;do
      $mpc current \
        | sed 's/"/'"'"'/g' \
        | sed 's/\(.*\)/{"full_text": "'"`$mpc | grep paused | sed 's/.*/   /g'`"'\1"}/g'
    done
  sleep 1s
done