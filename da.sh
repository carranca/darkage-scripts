#!/usr/local/bin/bash
#TODO: Actually read the server-side modified time from the variable in the config file (and get rid of MODIFIED_TIMES)
#TODO: Get the modified time from the CURL call and save it to the config file (http://stackoverflow.com/questions/2464760/modify-config-file-using-bash-script)

FILES=( 'login'  )
source da_update.cfg

declare -A MODIFIED_TIMES

MODIFIED_TIMES['login']="19700101 00:00:00 -0000"

for FILENAME in "${FILES[@]}"; 
do 
	FILENAME=$FILENAME.rar
	echo "Fetching $FILENAME"
	curl -s -o $FILENAME -z "${MODIFIED_TIMES[$FILENAME]}" http://www.darkagerp.com/release/$FILENAME

	if [ -e $FILENAME ]
	then
		if ! hash unrar 2>/dev/null; then
			echo 'Installing unrar dependency'
			brew install unrar
		fi

		unrar x $FILENAME
		rm $FILENAME
	fi
done


