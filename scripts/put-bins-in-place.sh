#!/usr/bin/env bash
set -euo pipefail

mv cardano-node/1.25.1/cardano-* /usr/local/bin/
mv libsodium/libsodium.* /usr/local/lib/

echo 'export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc
echo 'export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"' >> ~/.bashrc
source ~/.bashrc

rm -rf cardano-node libsodium

echo
# TODO: only to compile cardano-node binaries
# tar xvf cabal-install-3.4.0.0-aarch64-ubuntu-18.04.tar.xz
# mv cabal /usr/local/bin/
# rm cabal-install-3.4.0.0-aarch64-ubuntu-18.04.tar.xz

# tar xvf ghc-8.10.2-aarch64-deb10-linux.tar.xz
# apt install build-essential
# pushd ghc-8.10.2
# ./configure
# make install
# popd
