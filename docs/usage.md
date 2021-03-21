
# Table of Contents

1.  [Setup](#orgb32281f)
2.  [Upload and run setup](#orgc159dd5)
3.  [upload sattelite build scripts](#org025a399)
4.  [cncli on sattelite](#org932b91e)
5.  [download compiled](#org983fc92)
6.  [upload artefacts to nodes](#org08790d7)
7.  [start guild operation](#org733924b)
8.  [upload hot operation files](#orgb8ccd73)
9.  [fix permissions on hot operation files](#orgb7b60b2)



<a id="orgb32281f"></a>

# Setup


<a id="orgc159dd5"></a>

# Upload and run setup

    ssh -i $KEY_PATH root@$RELAY_HOST
    chmod +x ~/setup-server.sh
    ./setup-server.sh


<a id="org025a399"></a>

# upload sattelite build scripts

    ./upload.sh $SATTELITE_HOST $KEY_PATH setup-sat.sh setup-sat.sh
    ./upload.sh $SATTELITE_HOST $KEY_PATH build-cardano-node.sh build-cardano-node.sh


<a id="org932b91e"></a>

# cncli on sattelite

    ./upload.sh $SATTELITE_HOST $KEY_PATH setup-sat-cncli.sh setup-sat-cncli.sh
    ./upload.sh $SATTELITE_HOST $KEY_PATH build-cncli.sh build-cncli.sh


<a id="org983fc92"></a>

# download compiled

    ./download-files.sh $SATTELITE_HOST $KEY_PATH deps/cardano/build ./
    ./download-files.sh $SATTELITE_HOST $KEY_PATH deps/cncli/build ./


<a id="org08790d7"></a>

# upload artefacts to nodes

    ./upload.sh $RELAY_HOST $KEY_PATH node-setup.sh node-setup.sh
    ./upload.sh $PRODUCER_HOST $KEY_PATH build/ deps


<a id="org733924b"></a>

# start guild operation

    sudo cp build/cncli /usr/local/bin/
    sudo cp build/cardano-node/cardano-cli /usr/local/bin/
    sudo cp build/libsodium/libsodium.* /usr/local/lib/


<a id="orgb8ccd73"></a>

# upload hot operation files

    ./upload.sh $PRODUCER_HOST $KEY_PATH bp-op bp-op


<a id="orgb7b60b2"></a>

# fix permissions on hot operation files

    cd priv/pool
    chmod -o *
    chmod u+r *

