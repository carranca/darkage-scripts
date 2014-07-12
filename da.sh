#!/usr/local/bin/bash
#TODO: Get the modified time from the CURL call and save it to the config file (http://stackoverflow.com/questions/2464760/modify-config-file-using-bash-script)

FILES=( 'login'  )
source da_update.cfg

for FILENAME in "${FILES[@]}"; 
do 
	MODIFIED_TIME=${!FILENAME}
	FILENAME=$FILENAME.rar
	echo "Fetching $FILENAME, last fetched $MODIFIED_TIME"
	curl -s -o $FILENAME -z "$MODIFIED_TIME" http://www.darkagerp.com/release/$FILENAME

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


