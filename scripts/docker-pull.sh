#!/bin/bash

echo "List of available docker images:"
docker images
echo "----------------------------------"

read -p "Enter docker image name: " image_name
read -p "Enter docker image tag: " image_tag

docker pull "${image_name}:${image_tag}"

if [ $? -eq 0 ]; then
    echo "Docker-image ${image_name}:${image_tag} downloaded successfully."
else
    echo "Error with downloaded Docker-image ${image_name}:${image_tag}."
    exit 1
fi