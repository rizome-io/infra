#!/usr/bin/env bash
set -euo pipefail

export GIT_REPO_USER=shroomist
export GUILD_BRANCH=roast-edit

echo 'export GIT_REPO_USER=shroomist' >> ~/.bashrc

sudo cp deps/cncli /usr/local/bin/
sudo cp deps/cardano-node/cardano-* /usr/local/bin/
sudo cp deps/libsodium/libsodium.* /usr/local/lib/

curl -sS -o prereqs.sh https://raw.githubusercontent.com/${GIT_REPO_USER}/guild-operators/roast-edit/scripts/cnode-helper-scripts/prereqs.sh
chmod +x prereqs.sh
./prereqs.sh -k -b ${GUILD_BRANCH} -i
