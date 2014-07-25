#!/usr/local/bin/bash
#TODO: If file is not actually saved and extracted by unrar, we need to NOT save the newer modified time
#TODO: Show progress bar when downloading files
#TODO: Do not prompt for replacing, just replace by default

FILES=('client' 'def_files' 'full' 'hues' 'lgrping' 'login' 'map' 'multi' 'music' 'skills' 'staidx' 'staidx0' 'statics' 'statics0' 'tiledata' 'DA-files-patched')
CONFIG_FILE='da_update.cfg'
source $CONFIG_FILE

for FILE in "${FILES[@]}"; 
do 
	FILE_CONFIG_KEY=${FILE//-/_}
	MODIFIED_TIME=${!FILE_CONFIG_KEY}

	# DA-files-patched seems to be the only file that's a ZIP instead of a RAR
	if [ "$FILE" == "DA-files-patched" ]; then
		EXT="zip"
		DIRECTORY="files"
	else
		EXT="rar"
		DIRECTORY="release"
	fi

	FILENAME=$FILE.$EXT

	echo "Fetching $FILENAME, last fetched $MODIFIED_TIME"
	SERVER_MODIFIED_TIME=`curl -s -i -D /dev/stdout -o $FILENAME -z "$MODIFIED_TIME" http://www.darkagerp.com/$DIRECTORY/$FILENAME | tr -d '\r' | sed -En 's/^Last-Modified: (.*)/\1/p'`
	if [ -z "$SERVER_MODIFIED_TIME" ]; then
		echo "The local file is up to date."
		continue
	else
		echo "Found a newer file, last modified $SERVER_MODIFIED_TIME"
	fi

	if [ -e $FILENAME ]
	then
		if [ "$EXT" == "rar" ]; then
			if ! hash unrar 2>/dev/null; then
				echo 'Installing unrar dependency'
				brew install unrar
			fi

			echo "Extracting rar file"
			unrar x -y $FILENAME
		else
			echo "Extracting zip file"
			unzip -ov $FILENAME
		fi

		echo "Finished decompressing, removing compressed file now..."

		rm $FILENAME
		sed -i "bak" "s/\($FILE_CONFIG_KEY *= *\).*/\1\"$SERVER_MODIFIED_TIME\"/" $CONFIG_FILE
	fi
done

