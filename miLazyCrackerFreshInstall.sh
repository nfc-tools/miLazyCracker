#run this from inside miLazyCracker git repo

sudo apt-get install git
sudo apt-get install libnfc-bin
sudo apt-get install autoconf
sudo apt-get install libnfc-dev

#install MFOC
git clone https://github.com/nfc-tools/mfoc.git
cd mfoc
cp ../mfoc.c src/     #copy in modified mfoc.c 
sudo autoreconf -vfi
./configure
sudo make
sudo make install

cd ..

#install Hardnested Attack Tool
git clone https://github.com/aczid/crypto1_bs
cd crypto1_bs
cp ../libnfc_crypto1_crack.c .     #copy in modified .c 
make get_craptev1
make get_crapto1
make
sudo cp libnfc_crypto1_crack /usr/bin
