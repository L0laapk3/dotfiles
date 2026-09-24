#! /bin/env zsh

link_local() {
  mkdir -p ~dev/$USER/$1
  ln -sfT ~dev/$USER/$1 ~/$1
}

export DEFAULT_USER=$USER

[[ -r ~/.zprofile.local ]] && source ~/.zprofile.local

