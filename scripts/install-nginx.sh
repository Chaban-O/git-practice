#!/bin/bash
set -ex

#### Коли ви встановлюєте або оновлюєте пакети в режимі "неінтерактивного" інтерфейсу, система не запитує у користувача
# жодних запитів або підтверджень під час процесу встановлення. Це особливо корисно при автоматизації встановлення пакетів,
# наприклад, в сценаріях, контейнерах або під час налаштування серверів. ###
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y

sudo apt-get install -y nginx
echo "$(hostname -f)" | sudo tee /var/www/html/index.html

sudo systemctl enable nginx
sudo systemctl start nginx