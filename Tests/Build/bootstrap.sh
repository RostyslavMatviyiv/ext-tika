#!/usr/bin/env bash

test -n "$TIKA_PATH" || TIKA_PATH="$HOME/bin/"

# download Tika if not present
if [ ! -d "$TIKA_PATH" ]; then
	mkdir -p "$TIKA_PATH"
fi
if [ ! -f "$TIKA_PATH/tika-app-$TIKA_VERSION.jar" ]; then
	wget "http://apache.osuosl.org/tika/tika-app-$TIKA_VERSION.jar" -O "$TIKA_PATH/tika-app-$TIKA_VERSION.jar"
else
	echo "Cached $TIKA_PATH/tika-app-$TIKA_VERSION.jar present"
fi
if [ ! -f "$TIKA_PATH/tika-server-$TIKA_VERSION.jar" ]; then
	wget "http://apache.osuosl.org/tika/tika-server-$TIKA_VERSION.jar" -O "$TIKA_PATH/tika-server-$TIKA_VERSION.jar"
else
	echo "Cached $TIKA_PATH/tika-server-$TIKA_VERSION.jar present"
fi

if [ -f ./tika_pid ]; then
	TIKA_PID=cat ./tika_pid
	echo "Stopping Tika ($TIKA_PID)"
	kill $TIKA_PID
fi

# start tika server
echo "Starting Apache Tika"
TIKA_PID=`nohup java -jar "$TIKA_PATH/tika-server-$TIKA_VERSION.jar" > /dev/null 2>&1 & echo $!`
echo $TIKA_PID > tika_pid
echo "Tika pid: $TIKA_PID"

echo "PWD: $(pwd)"

composer require typo3/cms="$TYPO3_VERSION"
# Restore composer.json
git checkout composer.json
export TYPO3_PATH_WEB=$PWD/.Build/Web


mkdir -p $TYPO3_PATH_WEB/uploads $TYPO3_PATH_WEB/typo3temp
