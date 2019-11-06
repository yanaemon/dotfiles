#!/usr/bin/env zsh -ex

setup_homebrew() {
  if [ ! -x "`which brew`" ]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  sudo chown -R $(whoami) /usr/local/lib/pkgconfig
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

setup_zsh
setup_homebrew
