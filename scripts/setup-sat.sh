#!/usr/bin/env bash
set -euo pipefail

apt-get update && apt-get install -y \
  automake \
  build-essential \
  pkg-config \
  libffi-dev \
  libgmp-dev \
  libssl-dev \
  libtinfo-dev \
  libsystemd-dev \
  zlib1g-dev \
  make \
  g++ \
  tmux \
  git \
  jq \
  wget \
  libncursesw5 \
  libtool \
  autoconf

mkdir -p deps/cardano
pushd deps/cardano

# Build and install the IOHK fork of libsodium.
git clone https://github.com/input-output-hk/libsodium \
  && pushd libsodium \
  && git checkout 66f017f1 \
  && ./autogen.sh \
  && ./configure \
  && make -j16 \
  && make install \
  && popd
LD_LIBRARY_PATH="/usr/local/lib"
PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

mkdir -p build/libsodium
cp /usr/local/lib/libsodium* build/libsodium


# Install cabal
wget https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz \
  && tar -xf cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz \
  && rm cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz cabal.sig \
  && mv cabal /usr/local/bin/ \
  && cabal update

# Install GHC
wget https://downloads.haskell.org/ghc/8.10.2/ghc-8.10.2-x86_64-deb9-linux.tar.xz \
  && tar -xf ghc-8.10.2-x86_64-deb9-linux.tar.xz \
  && rm ghc-8.10.2-x86_64-deb9-linux.tar.xz \
  && pushd ghc-8.10.2 \
  && ./configure \
  && make install \
  && popd

git clone https://github.com/input-output-hk/cardano-node.git

popd

echo 'export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc
echo 'export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"' >> ~/.bashrc
