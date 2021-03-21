#!/usr/bin/env bash
set -euxo pipefail

# ${1} user
# ${2} host
# ${3} port
# ${4} key.pub

PORT=${3}
PORT_PART=""
if [ -z ${PORT+x} ];
then echo 'Using port 22';
else PORT_PART="-p ${3}";
fi
cat ${4} | ssh $PORT_PART ${1}@${2} "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
