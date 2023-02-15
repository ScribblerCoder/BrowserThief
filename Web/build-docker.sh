#!/bin/bash
docker rm -f browser_thief
docker rmi -f browser_thief
docker build -t browser_thief .
docker run -d --name=browser_thief --rm -p1337:1337 -it browser_thief
