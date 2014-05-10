#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

# Install essentials
sudo apt-get install -y curl python-software-properties python g++ make

# Add Required repository
sudo add-apt-repository -y ppa:cassou/emacs
sudo add-apt-repository -y ppa:chris-lea/node.js

# Update repo information
sudo apt-get -qq update

# 1. Install nodejs
#
# 2. Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
#
# 3. Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y nodejs emacs24-nox emacs24-el emacs24-common-non-dfsg rlwrap

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
sudo npm install -g jshint
sudo chown -R `whoami` ~/tmp

# git pull and install dotfiles as well
cd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
fi

git clone https://github.com/ivan-loh/dotfiles.git
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.bashrc_custom .
ln -sf dotfiles/.emacs.d .

# Complete emacs setup
cd dotfiles/.emacs.d
git clone https://github.com/auto-complete/popup-el.git
git clone https://github.com/auto-complete/auto-complete.git
