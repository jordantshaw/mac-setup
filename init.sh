#!/bin/bash

# Create 'repos' directory
mkdir -p ~/repos

# Install xcode tools
xcode-select --install

# Install OH-My-ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended

# Install Homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install all packages from BrewFile
export HOMEBREW_ACCEPT_EULA=y && brew bundle install

# Init pyenv
source ./scripts/init-pyenv.sh

