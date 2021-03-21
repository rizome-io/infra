#!/usr/bin/env bash
set -euo pipefail

DEFAULT_TAG=1.25.1
TAG=${1:-$DEFAULT_TAG}

export LD_LIBRARY_PATH="/usr/local/lib"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

cabal update
pushd deps/cardano/cardano-node \
  && git fetch --all --recurse-submodules --tags \
  && git checkout tags/$TAG \
  && cabal configure --with-compiler=ghc-8.10.2 \
  && echo "package cardano-crypto-praos" >>  cabal.project.local \
  && echo "  flags: -external-libsodium-vrf" >>  cabal.project.local \
  && cabal build -j16 all

OUT_DIR = "~/deps/cardano/build/cardano-node"

if [ -d $OUT_DIR ]
then
    echo "Directory already exists"
else
    mkdir -p $directory_name
fi

cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.2/cardano-node-$TAG/x/cardano-node/build/cardano-node/cardano-node $OUT_DIR
cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.2/cardano-cli-$TAG/x/cardano-cli/build/cardano-cli/cardano-cli $OUT_DIR

popd
