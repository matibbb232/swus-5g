#!/bin/sh

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install docker.io -y

sudo groupadd docker
sudo usermod -aG docker $USER
sudo newgrp docker

sudo systemctl enable docker
sudo systemctl start docker
