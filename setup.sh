# !/bin/bash

# Create 'repos' directory
mkdir -p ~/repos
mkdir -p ~/.ssl
mkdir -p ~/bin

# Install xcode tools
xcode-select --install

# Install OH-My-ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
if grep -Fxq 'eval "$(/opt/homebrew/bin/brew shellenv)"' ~/.zprofile
then
    echo "Homebrew already initialized: skipping..."
else
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install all packages from BrewFile
export HOMEBREW_ACCEPT_EULA=y && brew bundle install

# Init pyenv
if grep -Fxq 'export PYENV_ROOT="$HOME/.pyenv"' ~/.zshrc
then
    echo "pyenv already initialized: skipping..."
else
    echo '\n# ===============================\n# PYENV CONFIGURATION\n# ===============================' >> ~/.zshrc
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
    echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> ~/.zshrc
fi


# Setup bundled cert script
cp -fr ./scripts/bundle-certs.sh ~/bin/bundle-certs.sh
sh ~/bin/bundle-certs.sh ~/.ssl/bundled-cert.pem

if (crontab -l | grep -Fxq '*/30 * * * * bash ~/bin/bundle-certs.sh ~/.ssl/bundled-cert.pem')
then
    echo "'*/30 * * * * bash ~/bin/bundle-certs.sh ~/.ssl/bundled-cert.pem' already exsists: skipping..."
else
    (crontab -l 2>/dev/null; echo "*/30 * * * * bash ~/bin/bundle-certs.sh ~/.ssl/bundled-cert.pem") | crontab -
fi

if grep -Fxq 'export REQUESTS_CA_BUNDLE=$HOME/.ssl/bundled-cert.pem' ~/.zshrc
then
    echo "REQUESTS_CA_BUNDLE already added: skipping..."
else
    echo '\n# ===============================\n# CA BUNDLE\n# ===============================' >> ~/.zshrc
    echo 'export REQUESTS_CA_BUNDLE=$HOME/.ssl/bundled-cert.pem' >> ~/.zshrc
    echo 'export SSL_CERT_FILE=$HOME/.ssl/bundled-cert.pem' >> ~/.zshrc
fi
