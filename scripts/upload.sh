#!/usr/bin/env bash
set -euxo pipefail

# params
# ${1} user
# ${2} host
# ${3} port
# ${4} key
# ${5} file
# ${6} user home path
rsync -Pavz  -e "ssh -i ${4} -p ${3}"  ${5} ${1}@${2}:/home/${1}/${6}
