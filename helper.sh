#!/usr/bin/env bash

load_helper() {

  init() {
    clear
    echo -e '\n  ▓▓▓▓▓▓▓▓▓▓▓▓
 ░▓    about ▓ My dotfiles
 ░▓   author ▓ onlurking <diogofelix@acm.org>
 ░▓     code ▓ https://git.io/onlurking
 ░▓▓▓▓▓▓▓▓▓▓▓▓
 ░░░░░░░░░░░░\n'
  }

  ask() {
    # https://djm.me/ask
    local prompt default reply

    while true; do

      if test "${2:-}" = "Y"; then
        prompt="Y/n"
        default=Y
      elif test "${2:-}" = "N"; then
        prompt="y/N"
        default=N
      else
        prompt="y/n"
        default=
      fi

      echo -e -n "$1 [$prompt] "
      read -r reply < /dev/tty

      if [[ -z $reply ]]; then
        reply=$default
      fi

      case "$reply" in
        Y* | y*) return 0 ;;
        N* | n*) return 1 ;;
      esac

    done
  }

  requirements() {
    if ! test -x "$(command -v git)"; then

      # Arch
      if test -x "$(command -v pacman)"; then
        echo -e '\e[32m[ git ]\e[m not found, installing'
        sudo pacman -S git --noconfirm > /dev/null 2>&1
      fi

      # Alpine
      if test -x "$(command -v apk)"; then
        echo -e '\e[32m[ git ]\e[m not found, installing'
        sudo apk add git > /dev/null 2>&1
      fi

      # Ubuntu
      if test -x "$(command -v apt-get)"; then
        echo -e '\e[32m[ git ]\e[m not found, installing'
        sudo apt-get install -y git > /dev/null 2>&1
      fi

      # OSX
      if test -x "$(command -v brew)"; then
        echo -e '\e[32m[ git ]\e[m not found, installing'
        brew install git > /dev/null 2>&1
      fi

    fi
  }
}

load_helper
