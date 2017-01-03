#!/bin/bash

# uninstall dependencies
#sudo apt-get remove git
#sudo apt-get remove libnfc-bin
#sudo apt-get remove autoconf
#sudo apt-get remove libnfc-dev

# uninstall MFOC
sudo rm -f /usr/local/bin/mfoc /usr/local/share/man/man1/mfoc.1

# uninstall Hardnested Attack Tool
sudo rm -f /usr/local/bin/libnfc_crypto1_crack

# uninstall our script
sudo rm -f /usr/local/bin/miLazyCracker
