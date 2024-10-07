#!/bin/bash
set -ex

SECRET_ID="$1"
AWS_REGION="$2"

sudo apt install unzip curl -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
echo "aws --version"

SECRET_VALUE=$(aws secretsmanager get-secret-value --secret-id "${SECRET_ID}" --query SecretString --output text --region "${AWS_REGION}")

echo "SECRET=$SECRET_VALUE" >> /home/ubuntu/.env