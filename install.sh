#!/usr/bin/env zsh -ex

setup_homebrew() {
  if [ ! -x "`which brew`" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [ -d /usr/local/lib/pkgconfig ]; then
    sudo chown -R $(whoami) /usr/local/lib/pkgconfig
  fi

  if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  brew update
  brew bundle
}

setup_zsh() {
  if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  fi

  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    if [ ! -f "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    fi
  done

  chsh -s /bin/zsh
}

copy_dotfiles() {
  dotfiles=(
    .vimrc
    .zshrc
  )
  for dotfile in $dotfiles; do
    echo $dotfile
    cat $dotfile >| "${ZDOTDIR:-$HOME}/${dotfile}"
  done

  dotdirs=(
    .hammerspoon
  )
  for dotdir in $dotdirs; do
    echo $dotdir
    cp -r $dotdir "${ZDOTDIR:-$HOME}"
  done
}

setup_git() {
  #git config --global user.email
  #git config --global user.name
  git config --global core.editor vim
}

setup_zsh
setup_homebrew
setup_git
copy_dotfiles
