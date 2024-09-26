#!/bin/bash
set -ex

sudo apt-get update -y

sudo apt-get install -y nginx
echo "$(hostname -f)" | sudo tee /var/www/html/index.html

sudo systemctl enable nginx
sudo systemctl start nginx