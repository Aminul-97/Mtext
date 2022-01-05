UpperChars=("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "B" "W" "X" "Y" "Z")
LowerChars=("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")

#-----------Encryption process starts from here ----------------------
Additive () {
   Msg=$1
   key=$2
   len=${#Msg}
   if [[ "$3" == "Encrypt" ]]
   then
       for (( i=0; i<len; i++ ))
       do
          char=${Msg:$i:1}
          for (( j=0; j<26; j++ ))
          do
             UC=${UpperChars[$j]}
             LC=${LowerChars[$j]}
             if [[ $char == $UC ]]
             then
                 newPos=$(( (j+key)%26 ))
                 newChar=${UpperChars[$newPos]}
                 CMsg="$CMsg$newChar"
                 break
             elif [[ $char == $LC ]]
             then
                 newPos=$(( (j+key)%26 ))
                 newChar=${LowerChars[$newPos]}
                 CMsg="$CMsg$newChar"
                 break
             else
                 continue
             fi
          done
       done
   else 
     for (( i=0; i<len; i++ ))
       do
          char=${Msg:$i:1}
          for (( j=0; j<26; j++ ))
          do
             UC=${UpperChars[$j]}
             LC=${LowerChars[$j]}
             if [[ $char == $UC ]]
             then
                 if [ $j -lt $key ]
                 then
                     newPos=$(( (j-key+26)%26 ))
                 else
                     newPos=$(( (j-key)%26 ))
                 fi
                 newChar=${UpperChars[$newPos]}
                 CMsg="$CMsg$newChar"
                 break
             elif [[ $char == $LC ]]
             then
                 if [ $j -lt $key ]
                 then
                     newPos=$(( (j-key+26)%26 ))
                 else
                     newPos=$(( (j-key)%26 ))
                 fi
                 newChar=${LowerChars[$newPos]}
                 CMsg="$CMsg$newChar"
                 break
             else
                 continue
             fi
          done
       done
   fi
}

#--------------Program  GUI -------------------
message=$(zenity --forms --title="Mtext: A message locker" --text="Enter Message" \
   --add-entry="Text" 
   )
Operation=$(zenity --list --title "Choose Operation" --radiolist --column "ID" --column="Operation" 1 Encrypt 2 Decrypt)
OLEN=${#message}

#------------Separating String-------------------------
#searchstring="|"
#rest=${FormText#*$searchstring} 
#Separator=$(( ${#FormText} - ${#rest} - ${#searchstring} )) #finding the exact position of separator "|"

#key=${FormText[@]:Separator+1} #Collecting the message
#message=${FormText[@]:0:Separator} #Collecting the key

key=$(zenity --forms --title="Mtext: A message locker" --text="Key-1 " \
   --add-password="Key" 
   )

Additive $message $key $Operation
key1=$(zenity --forms --title="Mtext: A message locker" --text="Key-2" \
   --add-password="Key" 
   )
Additive $CMsg $key1 $Operation
key2=$(zenity --forms --title="Mtext: A message locker" --text="Key-3" \
   --add-password="Key" 
   )
Additive $CMsg $key2 $Operation
key3=$(zenity --forms --title="Mtext: A message locker" --text="Key-4" \
   --add-password="Key" 
   )
Additive $CMsg $key3 $Operation


LEN=${#CMsg}
POS=$(( LEN-OLEN ))
zenity --info --text=${CMsg:$POS:$OLEN} --width=500
echo ${CMsg:$POS:$OLEN} 