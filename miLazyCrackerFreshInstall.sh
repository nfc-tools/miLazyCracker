#!/bin/bash

set -x

# run this from inside miLazyCracker git repo

sudo apt-get install git libnfc-bin autoconf libnfc-dev

# install MFOC
[ -d mfoc ] || git clone https://github.com/nfc-tools/mfoc.git
(
    cd mfoc || exit 1
    git reset --hard
    git clean -dfx
    # tested against commit 9d9f01fb
    autoreconf -vfi
    ./configure
    make
    sudo make install
)

# install Hardnested Attack Tool
[ -d crypto1_bs ] || git clone https://github.com/aczid/crypto1_bs
(
    cd crypto1_bs || exit 1
    git reset --hard
    git clean -dfx
    # patch initially done against commit 957702be:
    patch -p1 < ../crypto1_bs.diff
    make get_craptev1
    make get_crapto1
    make
    sudo cp -a libnfc_crypto1_crack /usr/local/bin
)

# install our script
sudo cp -a miLazyCracker.sh /usr/local/bin/miLazyCracker
echo "Done."
