#!/bin/bash

cd /home/ubuntu/scripts
docker compose up -d 
sudo service codedeploy-agent restart
