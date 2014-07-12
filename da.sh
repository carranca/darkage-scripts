#!/usr/local/bin/bash
#TODO: Get the modified time from the CURL call and save it to the config file (http://stackoverflow.com/questions/2464760/modify-config-file-using-bash-script)

FILES=( 'login'  )
source da_update.cfg

for FILENAME in "${FILES[@]}"; 
do 
	MODIFIED_TIME=${!FILENAME}
	FILENAME=$FILENAME.rar
	echo "Fetching $FILENAME, last fetched $MODIFIED_TIME"
	SERVER_MODIFIED_TIME=`curl -s -i -D /dev/stdout -o $FILENAME -z "$MODIFIED_TIME" http://www.darkagerp.com/release/$FILENAME | tr -d '\r' | sed -En 's/^Last-Modified: (.*)/\1/p'`
	if [ -z "$SERVER_MODIFIED_TIME" ]; then
		echo "The local file is up to date."	
	else
		echo "Found a newer file, last modified $SERVER_MODIFIED_TIME"
	fi

	if [ -e $FILENAME ];
	then
		if ! hash unrar 2>/dev/null; then
			echo 'Installing unrar dependency'
			brew install unrar
		fi

		unrar x $FILENAME
		rm $FILENAME
	fi
done


