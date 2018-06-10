#!/bin/bash
set -eux

docker run --rm -d --entrypoint "/bin/sleep" --name emacsclient kiyoad/emacs 5
sleep 2
docker cp -a emacsclient:/usr/local/bin/emacsclient .

image_name=kiyoad/emacsclient
id=$(date '+%Y%m%d')

script -c "docker build -t ${image_name} ." "docker_build_${id}.log"
