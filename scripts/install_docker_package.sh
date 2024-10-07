#!/bin/bash
set -ex

sudo apt-get update -y

sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
UBUNTU_CODENAME=$(lsb_release -cs)
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" -y

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker ubuntu

sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl restart docker

sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose