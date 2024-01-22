#!/bin/bash

mkdir -p test

docker stop test-minimal-git-server > /dev/null 2>&1
docker rm test-minimal-git-server > /dev/null 2>&1

docker build -t test-minimal-git-server .
docker run -v ${PWD}/test/ssh:/srv/ssh -v ${PWD}/test/git:/srv/git -v ${PWD}/test/accounts:/srv/accounts \
        --env EXTERNAL_PORT=20222 --name test-minimal-git-server -d -p 20222:22 test-minimal-git-server

docker logs -f test-minimal-git-server