#!/usr/bin/env bash
set -euo pipefail

TAG=v1.3.0
git clone --recurse-submodules https://github.com/AndrewWestberg/cncli
pushd deps/cncli
git tags
git checkout $TAG
cargo build

OUT_DIR = "~/deps/cncli/build"

if [ -d $OUT_DIR ]
then
    echo "Directory already exists"
else
    mkdir -p $OUT_DIR
fi
cp target/debug/cncli $OUT_DIR

popd
