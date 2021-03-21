#!/usr/bin/env bash
set -euo pipefail


# params
# ${1} host
# ${2} key
# ${3} lovelace home path
# ${4} local file
scp -P 2222 -i ${2} -r lovelace@${1}:/home/lovelace/${3} ${4}
