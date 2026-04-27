#!/bin/bash
docker rmi *
docker-compose -f /home/ubuntu/scripts/docker-compose.yml down || true
