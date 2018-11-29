load_programs() {

  install_zsh() {
    if ! test -x "$(command -v zsh)"; then
      if test -x "$(command -v apt-get)"; then
        echo -e '\e[32m[ zsh ]\e[m not found, installing'
        sudo apt-get install -y zsh > /dev/null 2>&1
      fi

      if test -x "$(command -v apk)"; then
        echo -e '\e[32m[ git ]\e[m not found, installing'
        sudo apk add zsh > /dev/null 2>&1
      fi

      if test -x "$(command -v pacman)"; then
        echo -e '\e[32m[ zsh ]\e[m not found, installing'
        sudo pacman -S zsh --noconfirm > /dev/null 2>&1
      fi

      if test -x "$(command -v brew)"; then
        echo -e '\e[32m[ zsh ]\e[m not found, installing'
        brew install zsh > /dev/null 2>&1
      fi
    fi

    if test ! -d "$HOME/.oh-my-zsh"; then
      echo -e '\e[32m[ oh-my-zsh ]\e[m clonning repository'
      git clone git://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh" --quiet > /dev/null
      echo -e '\e[32m[ oh-my-zsh ]\e[m installing plugins'
      curl -fsLo "$HOME/.oh-my-zsh/themes/lambda-mod.zsh-theme" https://cdn.rawgit.com/onlurking/dotfiles/master/config/lambda-mod.zsh-theme
      git clone git://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" --quiet > /dev/null
      git clone git://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" --quiet > /dev/null
    else
      if ask '\e[32m[ oh-my-zsh ]\e[m configs found, overwrite?' Y; then
        rm -rf "$HOME/.oh-my-zsh"
        git clone git://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh" --quiet > /dev/null
        echo -e '\e[32m[ oh-my-zsh ]\e[m installing plugins'
        curl -fsLo "$HOME/.oh-my-zsh/themes/lambda-mod.zsh-theme" https://cdn.rawgit.com/onlurking/dotfiles/master/config/lambda-mod.zsh-theme
        git clone git://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" --quiet > /dev/null
        git clone git://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" --quiet > /dev/null
      fi
    fi

    if test -f $HOME/.zshrc; then
      if ask '\e[32m[ .zshrc ]\e[m found, make backup?' Y; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
        echo -e '\e[32m[ .zshrc ]\e[m saved to .zshrc.bak'
      fi
    fi

    if test -f $HOME/.profile; then
      if ask '\e[32m[ .profile ]\e[m found, make backup?' Y; then
        cp "$HOME/.profile" "$HOME/.profile.bak"
        echo -e '\e[32m[ .profile ]\e[m saved to .profile.bak'
      fi
    fi

    cat << 'EOF' > $HOME/.zshrc
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="lambda-mod"
VISUAL="nvim"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias cp="cp -rv"
alias rm="rm -rv"
alias mv="mv -v"

alias g="git"
alias gh="hub"

alias ka="kiall"
alias cl="clear"
alias h="history"
alias q="exit"

source $HOME/.profile
source $ZSH/oh-my-zsh.sh
EOF

    mkdir -p $HOME/.local/bin
    cat << 'EOF' > $HOME/.profile
export PATH=$PATH:$HOME/.local/bin
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

export TERM="xterm-256color"
EOF

    cat << 'EOF' > $HOME/.oh-my-zsh/themes/lambda-mod.zsh-theme
#!/usr/bin/env zsh

local LAMBDA="%(?,%{$fg_bold[green]%}λ,%{$fg_bold[red]%}λ)"
if [[ "$USER" == "root" ]]; then USERCOLOR="red"; else USERCOLOR="yellow"; fi

# Git sometimes goes into a detached head state. git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string.
function check_git_prompt_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [[ -z $(git_prompt_info 2> /dev/null) ]]; then
            echo "%{$fg[blue]%}detached-head%{$reset_color%}) $(git_prompt_status)
%{$fg[yellow]%}→ "
        else
            echo "$(git_prompt_info 2> /dev/null) $(git_prompt_status)
%{$fg_bold[cyan]%}→ "
        fi
    else
        echo "%{$fg_bold[cyan]%}→ "
    fi
}

function get_right_prompt() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -n "$(git_prompt_short_sha)%{$reset_color%}"
    else
        echo -n "%{$reset_color%}"
    fi
}

PROMPT=$'\n'$LAMBDA'\
 %{$fg_bold[$USERCOLOR]%}%n\
 %{$fg_no_bold[magenta]%}[%3~]\
 $(check_git_prompt_info)\
%{$reset_color%}'

RPROMPT='$(get_right_prompt)'

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="at %{$fg[blue]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ✔"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$fg_bold[white]%}^"


# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg_bold[white]%}[%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg_bold[white]%}]"
EOF

    echo -e '\e[32m[ zsh ]\e[m changing user shell to zsh'
    chsh -s $(which zsh) $USER
    echo -e '\e[32m[ zsh ]\e[m shell changed, please logout or reboot to take effect'
  }

  function install_docker() {
    if ! test -x "$(command -v docker)"; then

      if test -x "$(command -v apt-get)"; then
        echo -e '\e[32m[ docker ]\e[m not found, installing'
        sudo apt-get install -y docker docker-compose > /dev/null 2>&1
      fi

      if test -x "$(command -v pacman)"; then
        echo -e '\e[32m[ docker ]\e[m not found, installing'
        sudo pacman -S docker docker-compose --noconfirm > /dev/null 2>&1
      fi

      if test -x "$(command -v brew)"; then
        echo -e '\e[32m[ docker ]\e[m not found, installing'
        brew install docker docker-compose > /dev/null 2>&1
      fi

    fi

    echo -e '\e[32m[ docker ]\e[m starting docker service'
    sudo systemctl enable --now docker.service > /dev/null 2>&1

    echo -e '\e[32m[ docker ]\e[m configuring docker'
    sudo groupadd docker > /dev/null 2>&1
    sudo gpasswd -a $USER docker > /dev/null 2>&1

    echo -e '\e[32m[ docker ]\e[m running docker hello-world test'

    newgrp docker << END
docker run hello-world

if [ $? -eq 0 ]; then
    echo -e "\\e[32m[ docker ]\\e[m Docker installed, please logout or reboot"
else
    echo -e "\\e[32m[ docker ]\\e[m Docker installation failed"
fi
END
  }

  install_nvim() {
    if ! [ -x "$(command -v nvim)" ]; then

      if [ -x "$(command -v apt-get)" ]; then
        echo -e '\e[32m[ neovim ]\e[m not found, installing'
        sudo apt-get install -y neovim > /dev/null 2>&1
      fi

      if [ -x "$(command -v pacman)" ]; then
        echo -e '\e[32m[ neovim ]\e[m not found, installing'
        sudo pacman -S neovim --noconfirm > /dev/null 2>&1
      fi

      if [ -x "$(command -v brew)" ]; then
        echo -e '\e[32m[ nvim ]\e[m not found, installing'
        brew install neovim > /dev/null 2>&1
      fi
    fi

    curl -fsLo "$HOME/.config/nvim/autoload/plug.vim" --create-dirs https://cdn.rawgit.com/onlurking/dotfiles/master/config/nvim/autoload/plug.vim
    curl -fsLo "$HOME/.config/nvim/colors/Tomorrow-Night-Eighties.vim" --create-dirs https://cdn.rawgit.com/onlurking/dotfiles/master/config/nvim/colors/Tomorrow-Night-Eighties.vim
    curl -fsLo "$HOME/.config/nvim/init.vim" --create-dirs https://cdn.rawgit.com/onlurking/dotfiles/master/config/nvim/init.vim
    curl -fsLo "$HOME/.config/nvim/ginit.vim" --create-dirs https://cdn.rawgit.com/onlurking/dotfiles/master/config/nvim/ginit.vim

  }

  install_nodejs() {
    if ! [ -x "$(command -v node)" ]; then

      if [ -x "$(command -v apt-get)" ]; then
        echo -e '\e[32m[ node ]\e[m not found, installing'
        sudo apt-get install -y node npm yarn > /dev/null 2>&1
      fi

      if [ -x "$(command -v pacman)" ]; then
        echo -e '\e[32m[ node ]\e[m not found, installing'
        sudo pacman -S nodejs npm yarn --noconfirm > /dev/null 2>&1
      fi

      if [ -x "$(command -v brew)" ]; then
        echo -e '\e[32m[ node ]\e[m not found, installing'
        brew install nodejs npm yarn > /dev/null 2>&1
      fi
    fi

    mkdir -p "$HOME/.npm-packages"
    npm set prefix "$HOME/.npm-packages" > /dev/null 2>&1

    cat << 'EOF' >> $HOME/.profile
export PATH=$PATH:$HOME/.npm-packages/bin
EOF

    if [ -x "$(command -v yarn)" ]; then
      yarn config set prefix "$HOME/.npm-packages" > /dev/null 2>&1
    fi

  }

  install_golang() {
    if ! [ -x "$(command -v go)" ]; then

      if [ -x "$(command -v apt-get)" ]; then
        echo -e '\e[32m[ go ]\e[m not found, installing'
        sudo apt-get install -y go > /dev/null 2>&1
      fi

      if [ -x "$(command -v pacman)" ]; then
        echo -e '\e[32m[ go ]\e[m not found, installing'
        sudo pacman -S go go-tools --noconfirm > /dev/null 2>&1
      fi

      if [ -x "$(command -v brew)" ]; then
        echo -e '\e[32m[ go ]\e[m not found, installing'
        brew install go go-tools > /dev/null 2>&1
      fi

    fi

    mkdir -p $HOME/.go

    cat << 'EOF' >> $HOME/.profile
export GOPATH=$HOME/.go
export PATH=$PATH:$HOME/.go/bin
EOF

  }

}

load_programs
