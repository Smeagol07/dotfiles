#!/bin/bash
#=================================================
# name:   network-sync.sh
# author: Pawel Bogut <https://pbogut.me>
# date:   22/05/2021
#=================================================
trickle=""
action=""
quiet=""
force=""
debug=""

while test $# -gt 0; do
  case "$1" in
    all)
      action="inbox"
      shift
      ;;
    inbox)
      action="inbox"
      shift
      ;;
    mail)
      action="mail"
      shift
      ;;
    calendar)
      action="calendar"
      shift
      ;;
    --trickle)
      trickle="trickle -s -d 1024 -u 1024"
      shift
      ;;
    --quiet)
      quiet="yes"
      shift
      ;;
    --debug)
      debug="yes"
      shift
      ;;
    --force)
      force="yes"
      shift
      ;;
    enable)
      action="enable"
      shift
      ;;
    disable)
      action="disable"
      shift
      ;;
    status)
      action="status"
      shift
      ;;
  esac
done


if [[ $debug == "yes" ]]; then
  echo "---debug---"
  echo "Parameters:"
  echo "  trickle: $trickle"
  echo "  action:  $action"
  echo "  quiet:   $quiet"
  echo "  force:   $force"
fi

run() {
  if [[ $debug == "yes" ]]; then
    echo "Running: $@"
    echo "---"
  fi
  eval "$@"
}

print_status() {
  run [[ -f ~/.netsync-enabled ]] && echo "AutoSync Enabled" || echo "AutoSync Disabled"
}

# enable / disable / status
if [[ $action == "enable" ]]; then
  run touch ~/.netsync-enabled > /dev/null 2>&1
  print_status
fi
if [[ $action == "disable" ]]; then
  rm -fr touch ~/.netsync-enabled > /dev/null 2>&1
  print_status
fi
if [[ $action == "status" ]]; then
  print_status
fi

# check status
if [[ ! -f ~/.netsync-enabled ]] && [[ $force != "yes" ]]; then
  if [[ $quiet != "yes" ]]; then
    echo "Doing nothing, sync disabled"
  fi
  exit
fi


# sync inbox
if [[ $action == "inbox" ]]; then
  [[ $quiet == "yes" ]] && quiet="-u quiet"
  run "OFFLINEIMAP_INBOX_ONLY=1 $trickle offlineimap $quiet"
fi

# sync full email
if [[ $action == "inbox" ]] || [[ $action == "all" ]]; then
  [[ $quiet == "yes" ]] && quiet="-u quiet"
  run "$trickle offlineimap $quiet"
fi

# sync calendars
if [[ $action == "calendar" ]] || [[ $action == "all" ]]; then
  if [[ $quiet == "yes" ]]; then
    run "$trickle vdirsyncer sync 2>&1 | grep -v '^Syncing '"
  else
    run "$trickle vdirsyncer sync 2>&1"
  fi
fi
