#!/bin/bash
set -euo pipefail

mode=${1}
logname=${2}
password=${3}
uid=${4}
shift
shift
shift
shift

useradd -u "${uid}" -p $(echo "${password}" | mkpasswd -s -m sha-512) -s /bin/bash "${logname}"
echo "${logname} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${logname}"
chmod 0440 "/etc/sudoers.d/${logname}"

chown "${logname}:${logname}" "/tmp/emacs${uid}"
chmod go-rwx "/tmp/emacs${uid}"

if [[ ${mode} = "cui" ]]; then
    export TERM=xterm-256color
    sudo -i -u "${logname}" /usr/local/bin/emacs "$@"
else
    sed -i -e "s/@USERNAME/${logname}/" -e "s/@PASSWORD/${password}/" /etc/xrdp/xrdp.ini
    sudo -i -u "${logname}" /usr/local/sbin/startup.sh "$@"
fi
