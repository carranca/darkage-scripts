#!/usr/local/bin/bash
#TODO: If file is not actually saved and extracted by unrar, we need to NOT save the newer modified time

FILES=( 'login'  )
CONFIG_FILE='da_update.cfg'
source $CONFIG_FILE

for FILE in "${FILES[@]}"; 
do 
	MODIFIED_TIME=${!FILE}
	FILENAME=$FILE.rar
	echo "Fetching $FILENAME, last fetched $MODIFIED_TIME"
	SERVER_MODIFIED_TIME=`curl -s -i -D /dev/stdout -o $FILENAME -z "$MODIFIED_TIME" http://www.darkagerp.com/release/$FILENAME | tr -d '\r' | sed -En 's/^Last-Modified: (.*)/\1/p'`
	if [ -z "$SERVER_MODIFIED_TIME" ]; then
		echo "The local file is up to date."	
		continue
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

		sed -i "bak" "s/\($FILE *= *\).*/\1\"$SERVER_MODIFIED_TIME\"/" $CONFIG_FILE
	fi
done


