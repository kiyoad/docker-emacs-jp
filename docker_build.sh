#!/bin/bash
set -eux

image_name=kiyoad/emacs
id=$(date '+%Y%m%d')

#sudo bash -c "echo 0 > /proc/sys/kernel/randomize_va_space"
script -c "docker build --build-arg INSTALL_USER=${LOGNAME} --build-arg UID=$(id -u) -t ${image_name} ." docker_build_${id}.log
