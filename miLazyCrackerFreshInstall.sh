#!/bin/bash
set -e

# try to get craptev1-v1.1.tar.xz and crapto1-v3.3.tar.xz
# 2550aa92fcb504b62dbc4a978c51d283f34ed2d393ea0c55444dc4bf5cd3c4e4  craptev1-v1.1.tar.xz
# c116df63d88bea2966b98cf77170a7382585789b9e47088766e167a666230a20  crapto1-v3.3.tar.xz
[ -f craptev1-v1.1.tar.xz ] || wget https://web.archive.org/web/20190221140220if_/https://www2.vaneay.fr/mifare/craptev1-v1.1.tar.xz
[ -f crapto1-v3.3.tar.xz ] || wget https://web.archive.org/web/20190221140255if_/https://www2.vaneay.fr/mifare/crapto1-v3.3.tar.xz

if [ ! -f craptev1-v1.1.tar.xz ] || [ ! -f crapto1-v3.3.tar.xz ]; then
    echo "I need craptev1-v1.1.tar.xz and crapto1-v3.3.tar.xz. Aborting."
    exit 1
fi

set -x

# run this from inside miLazyCracker git repo
if [ -f "/etc/debian_version" ]; then
    pkgs=""
    for pkg in git libnfc-bin autoconf libnfc-dev; do
        if ! dpkg -l $pkg >/dev/null 2>&1; then
            pkgs="$pkgs $pkg"
        fi
    done
    if [ "$pkgs" != "" ]; then
        sudo apt-get install $pkgs -y || true
    fi
fi

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
    # patch initially done against commit 89de1ba5:
    patch -p1 < ../crypto1_bs.diff
    tar Jxvf ../craptev1-v1.1.tar.xz
    mkdir crapto1-v3.3
    tar Jxvf ../crapto1-v3.3.tar.xz -C crapto1-v3.3
    make
    sudo cp -a libnfc_crypto1_crack /usr/local/bin
)

# install our script
sudo cp -a miLazyCracker.sh /usr/local/bin/miLazyCracker
echo "Done."
