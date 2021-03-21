#!/usr/bin/env bash
set -euo pipefail

cat ./sever-setup.sh | ssh -i $2 root@$1 "cat >> ~/setup-server.sh"
