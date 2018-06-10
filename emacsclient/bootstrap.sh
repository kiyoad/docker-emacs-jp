#!/bin/bash
set -eu
logname=${1}
uid=${2}
shift
shift
useradd -u "${uid}" -s /bin/bash "${logname}"
sudo -i -u "${logname}" /usr/local/bin/emacsclient_wrapper.sh "$@"
