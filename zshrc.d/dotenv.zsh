#!/bin/bash
#============================================================
# name:   dotenv.zsh
# author: Pawel Bogut <pbogut@ukpos.com> <http://pbogut.me>
# date:   31/03/2017
#============================================================
# based on: https://github.com/builtinnya/dotenv-shell-loader
#============================================================
dotenv () {
  set -o allexport
  [ -f ${DOT_ENV:-.env} ] && source .env
  set +o allexport
  [[ -x $(command -v "$1") ]] && "${@:1}"
}

