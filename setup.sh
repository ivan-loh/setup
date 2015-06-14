#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

# Install essentials
sudo apt-get install -y curl python-software-properties python g++ make

# Add Required repository
sudo add-apt-repository -y ppa:cassou/emacs
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo add-apt-repository -y ppa:chris-lea/zeromq
sudo add-apt-repository -y ppa:chris-lea/redis-server
sudo add-apt-repository -y ppa:keithw/mosh
sudo add-apt-repository ppa:nginx/stable
sudo add-apt-repository -y ppa:webupd8team/java

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key 505A7412
echo "deb [arch=amd64] http://s3.amazonaws.com/tokumx-debs $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/tokumx.list


# Update repo information && accept java license
sudo apt-get update -y
sudo apt-get upgrade -y
sudo echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections


# 1. Install Dev Software
sudo apt-get install -y htop gcc build-essential nodejs emacs24-nox emacs24-el emacs24-common-non-dfsg rlwrap libzmq3-dev redis-server tokumx mosh oracle-java8-installer maven nginx

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
sudo npm install -g jshint forever grunt grunt-cli yo bower
sudo chown -R `whoami` ~/.npm
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
ln -sb dotfiles/.emacs.d .

# Complete emacs setup
cd dotfiles/.emacs.d/lisp
git clone https://github.com/auto-complete/popup-el.git
git clone https://github.com/auto-complete/auto-complete.git

# gitignore_global
wget https://gist.githubusercontent.com/octocat/9257657/raw/c91b435be351fcdff00f6f97f20824d0286b99ef/.gitignore
mv .gitignore ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global


sudo dpkg-reconfigure tzdata
