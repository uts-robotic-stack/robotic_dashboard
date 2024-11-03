#!/bin/bash

docker rm -f robotic_dashboard
docker run -d \
    -p="9090:9090" \
    --name robotic_dashboard \
    dkhoanguyen/robotic_dashboard:latest 
