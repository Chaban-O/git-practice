#!/bin/bash
set -ex

sudo wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb
sudo apt-get -f -y install
sudo systemctl stop amazon-cloudwatch-agent
sleep 10

echo "{
  \"metrics\": {
    \"append_dimensions\": {
      \"InstanceId\": \"$(curl -s http://169.254.169.254/latest/meta-data/instance-id)\"
    },
    \"metrics_collected\": {
      \"mem\": {
        \"measurement\": [
          \"mem_used_percent\"
        ],
        \"metrics_collection_interval\": 5
      }
    }
  }
}" | sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

sleep 5
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
sleep 5
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json