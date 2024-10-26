#!/usr/bin/sh

docker build -t privesc:latest .
docker rm privesc
docker run --rm --name privesc -it privesc:latest