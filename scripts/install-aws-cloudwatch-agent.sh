#!/bin/bash

set -ex
# Отримання Instance ID з параметра
INSTANCE_ID="$1"

# Оновлення системи
sudo apt-get update -y
sudo apt-get install -y amazon-cloudwatch-agent

# Створення конфігураційного файлу для CloudWatch Agent
sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json > /dev/null <<EOT
{
  "metrics": {
    "append_dimensions": {
      "InstanceId": "$INSTANCE_ID"
    },
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 60
      }
    }
  }
}
EOT

# Запуск агента CloudWatch
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start
