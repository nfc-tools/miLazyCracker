# miLazyCracker
Mifare Classic Plus - Hardnested Attack Implementation for LibNFC USB readers (SCL3711, ASK LoGO, etc)

Installation:

Installation used to be very easy but the original CraptEV1 / Crapto1 source packages are not made available anymore by their author, therefore you've to find a copy of these two packages by yourself
because redistribution of CraptEV1 is not allowed by its license.

```bash
# wget http://crapto1.netgarage.org/craptev1-v1.1.tar.xz
# wget http://crapto1.netgarage.org/crapto1-v3.3.tar.xz
./miLazyCrackerFreshInstall.sh
```

Usage example: place a tag and enjoy
```bash
mkdir mydumps
cd mydumps
miLazyCracker
```

Possible issue: 
```bash
error	libnfc.driver.pn53x_usb	Unable to set USB configuration (Device or resource busy)
```
Fix: 
```bash
sudo modprobe -r pn533_usb
```



This tool is comprised of work from:
-  Aram Verstegen (https://github.com/aczid/crypto1_bs) 

-  Carlo Meijer and Roel Verdult: (http://www.cs.ru.nl/~rverdult/Ciphertext-only_Cryptanalysis_on_Hardened_Mifare_Classic_Cards-CCS_2015.pdf)

-  Iceman Proxmark Branch: https://github.com/iceman1001/proxmark

-  Piwi Proxmark Branch - https://github.com/pwpiwi/proxmark3/tree/hard_nested

-  Blahpost Solver

-  MFOC - https://github.com/nfc-tools/mfoc

-  MFCUK - https://github.com/nfc-tools/mfcuk

