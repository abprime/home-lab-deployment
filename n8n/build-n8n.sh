#!/bin/bash

docker build -t localhost:5000/n8n:latest .

docker push localhost:5000/n8n:latest