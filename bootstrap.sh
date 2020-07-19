#!/bin/bash
set -eu

logname=${1}
uid=${2}
shift
shift

useradd -u "${uid}" -s /bin/bash "${logname}"
echo "${logname} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${logname}"
chmod 0440 "/etc/sudoers.d/${logname}"

chown "${logname}:${logname}" "/tmp/emacs${uid}"
chmod go-rwx "/tmp/emacs${uid}"

export TERM=xterm-256color
sudo -u "${logname}" -i /usr/local/bin/emacs "$@"
