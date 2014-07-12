#!/usr/local/bin/bash

declare -A MODIFIED_TIMES

MODIFIED_TIMES['login.rar']="19700101 00:00:00 -0000"

for FILENAME in "${!MODIFIED_TIMES[@]}"; 
do 
	echo "Fetching $FILENAME"
	curl -s -o $FILENAME -z "${MODIFIED_TIMES[$FILENAME]}" http://www.darkagerp.com/release/$FILENAME

	if [ -e $FILENAME ]
	then
		echo 'Huzzah!'
		if ! hash unrar 2>/dev/null; then
			echo 'Installing unrar dependency'
			brew install unrar
		fi

		unrar x $FILENAME
		rm $FILENAME
	fi
done


