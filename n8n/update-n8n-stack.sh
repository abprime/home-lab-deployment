#!/bin/bash

set -e

./build-n8n.sh

docker stack rm n8n

sleep 10

docker stack deploy -c docker-compose.yml n8n