fish_vi_key_bindings

# disable greeting
set fish_greeting

# aliases
alias q exit
alias so source

alias vim nvim
alias m ncmpcpp

function ncmpcpp
  set -l LC_ALL en_GB.utf8
  set -q MOPIDY_PORT; or set -l MOPIDY_PORT 6600
  screen -U -D -RR ncmpcpp ncmpcpp -p $MOPIDY_PORT $argv
end
