#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Post install steps for ubuntu server.
apt update -yq
apt upgrade -yq

# Install docker

# Requirements
apt update
apt install python apt-transport-https ca-certificates curl gnupg-agent software-properties-common git zsh -yq

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update -yq
apt install docker-ce docker-ce-cli containerd.io -yq
usermod -aG docker ubuntu
systemctl enable docker
systemctl start docker

# Docker compose
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Oh my zsh :)
# chsh -s $(which zsh) root
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ulimits
echo "fs.file-max = 999999" >> /etc/sysctl.conf
sysctl -p

echo "* hard nofile 999999" >> /etc/security/limits.conf
echo "* soft nofile 999999" >> /etc/security/limits.conf
echo "root hard nofile 999999" >> /etc/security/limits.conf
echo "root soft nofile 999999" >> /etc/security/limits.conf
