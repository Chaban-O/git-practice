#!/bin/bash
set -ex

read -p "Enter docker image tag: " image_tag

AWS_PUSH_CREDS=699475951891.dkr.ecr.us-east-1.amazonaws.com/chaban/test-space:${image_tag}

# перевірка на те що тег не порожній
if [ -z "$image_tag" ]; then
    echo "Tag cant be empty"
    exit 1
fi

docker build -t "${image_tag}" ../Python-api
echo "Build successfully with tag ${image_tag}"

echo "List of available docker images:"
docker images
echo "----------------------------------"

docker tag "${image_tag}":latest "${AWS_PUSH_CREDS}"
docker push "${AWS_PUSH_CREDS}"

if [ $? -eq 0 ]; then
    echo "Docker images ${AWS_PUSH_CREDS} with tag ${image_tag} pushed successfully to AWS ECG"
else
    echo "Error with pushing Docker-image ${AWS_PUSH_CREDS}"
    exit 1
fi
