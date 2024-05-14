#!/bin/bash

#reference: https://www.bytebase.com/docs/get-started/self-host/#docker
set -xe

mkdir -p ~/bytebase

pushd ~/bytebase

sudo apt update
sudo apt install -y libkrb5-dev

export DOCKER_BUILDKIT=0
echo "export DOCKER_BUILDKIT=0" >> ~/.bashrc

# cd ~/bytebase
git clone https://github.com/AlanZheng2580/bytebase.git
cd bytebase/scripts
git checkout fork/2.16.0
sed -i '/Dockerfile/a --build-arg TARGETARCH="amd64" \\' ~/bytebase/bytebase/scripts/build_bytebase_docker.sh
./build_bytebase_docker.sh

popd

# add "PATH=/usr/bin:/usr/local/go/bin:$PATH"
