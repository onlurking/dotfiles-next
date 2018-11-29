#!/usr/bin/env bash
set -o errexit
set -o pipefail

# source files from folder if they are present
# otherwise, source through curl
if test -f "$(pwd)/helper.sh"; then
  baseurl=$(pwd)
  . "${baseurl}/helper.sh"
  . "${baseurl}/programs.sh"
  _install_mode='\e[32mlocal\e[m'
else
  baseurl='https://onlurking-dotfiles.surge.sh'
  source <(curl -s "${baseurl}/helper.sh")
  source <(curl -s "${baseurl}/programs.sh")
  _install_mode='\e[5m\e[31mremote \e[m'
fi

init && requirements

while [[ $# -gt 0 ]]; do
  case $1 in
    -z | --zsh)
      zsh=true
      ;;
    -p | --python)
      python=true
      ;;
    -n | --node | --nodejs)
      nodejs=true
      ;;
    -r | --ruby)
      ruby=true
      ;;
    -g | --git)
      golang=true
      ;;
    -go | --golang)
      golang=true
      ;;
    -t | --tmux)
      tmux=true
      ;;
    -e | --elixir)
      elixir=true
      ;;
    -n | --neovim)
      neovim=true
      ;;
    -pg | --postgres | --postgresql)
      postgres=true
      ;;
    -h | --help)
      usage=true
      ;;
    *) echo -e "Unknown options:' $1" ;;
  esac
  shift
done

if [ $usage ]; then
  printf " installation mode: ${_install_mode}

 \\e[32musage\\e[m:
    -h | --help \t show this help text
    -z | --zsh \t configure zsh with oh-my-zsh
\n" | expand -t 20
fi

if [ $zsh ]; then
  install_zsh
fi
