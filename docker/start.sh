#!/usr/bin/sh

docker build -t privesc .
docker rm privesc
docker run --name privesc -it privesc