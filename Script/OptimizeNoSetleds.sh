#!/bin/bash

echo "
************************************************************************************
                                                                                   
    https://github.com/xiaoMGitHub/LEGION_Y7000Series_Hackintosh/releases  
                                                                                  
************************************************************************************
"

DAEMON_PATH=/Library/LaunchDaemons/
BIN_PATH=/usr/local/bin/
TMP_PATH=/tmp/
ALC_DAEMON_FILE=good.win.ALCPlugFix.plist
VERB_FILE=hda-verb
ALC_FIX_FILE=ALCPlugFix
TIME_FIX_FILE=localtime-toggle
TIME_DAEMON_FILE=org.osx86.localtime-toggle.plist
GIT_URL=https://gitee.com/xiaoMGit/Y7000Series_Hackintosh_Fix/raw/master

sudo spctl --master-disable
sudo pmset -a hibernatemode 0
sudo rm -rf /var/vm/sleepimage
sudo mkdir /var/vm/sleepimage

sudo curl -s -o $TMP_PATH$ALC_FIX_FILE "$GIT_URL/ALCPlugFix/$ALC_FIX_FILE"
sudo curl -s -o $TMP_PATH$VERB_FILE "$GIT_URL/ALCPlugFix/$VERB_FILE"
sudo curl -s -o $TMP_PATH$ALC_DAEMON_FILE "$GIT_URL/ALCPlugFix/$ALC_DAEMON_FILE"
sudo curl -s -o $TMP_PATH$TIME_FIX_FILE "$GIT_URL/TimeSynchronization/$TIME_FIX_FILE"
sudo curl -s -o $TMP_PATH$TIME_DAEMON_FILE "$GIT_URL/TimeSynchronization/$TIME_DAEMON_FILE"

if sudo launchctl list | grep --quiet com.black-dragon74.ALCPlugFix; then
    sudo launchctl unload /Library/LaunchDaemons/com.black-dragon74.ALCPlugFix.plist
	sudo rm /Library/LaunchDaemons/com.black-dragon74.ALCPlugFix.plist
	sudo rm /usr/local/bin/ALCPlugFix
	sudo rm /Library/Preferences/ALCPlugFix/ALC_Config.plist
fi

if [ ! -d "$BIN_PATH" ] ; then
    mkdir "$BIN_PATH" ;
fi

sudo cp $TMP_PATH$ALC_FIX_FILE $BIN_PATH
sudo cp $TMP_PATH$VERB_FILE $BIN_PATH
sudo cp $TMP_PATH$ALC_DAEMON_FILE $DAEMON_PATH
sudo cp $TMP_PATH$TIME_FIX_FILE $BIN_PATH
sudo cp $TMP_PATH$TIME_DAEMON_FILE $DAEMON_PATH
sudo cp $TMP_PATH$NUMLOCK_FIX_FILE $BIN_PATH
sudo cp $TMP_PATH$NUMLOCK_DAEMON_FILE $DAEMON_PATH
sudo rm $TMP_PATH$ALC_FIX_FILE
sudo rm $TMP_PATH$VERB_FILE
sudo rm $TMP_PATH$ALC_DAEMON_FILE
sudo rm $TMP_PATH$TIME_FIX_FILE
sudo rm $TMP_PATH$TIME_DAEMON_FILE

sudo chmod 755 $BIN_PATH$ALC_FIX_FILE
sudo chown $USER:admin $BIN_PATH$ALC_FIX_FILE
sudo chmod 755 $BIN_PATH$VERB_FILE
sudo chown $USER:admin $BIN_PATH$VERB_FILE
sudo chmod 644 $DAEMON_PATH$ALC_DAEMON_FILE
sudo chown root:wheel $DAEMON_PATH$ALC_DAEMON_FILE

sudo chmod +x $BIN_PATH$TIME_FIX_FILE
sudo chown root $DAEMON_PATH$TIME_DAEMON_FILE
sudo chmod 644 $DAEMON_PATH$TIME_DAEMON_FILE

if sudo launchctl list | grep --quiet ALCPlugFix; then
    sudo launchctl unload $DAEMON_PATH$ALC_DAEMON_FILE
fi
sudo launchctl load -w $DAEMON_PATH$ALC_DAEMON_FILE

if sudo launchctl list | grep --quiet localtime-toggle; then
    sudo launchctl unload $DAEMON_PATH$TIME_DAEMON_FILE
fi
sudo launchctl load -w $DAEMON_PATH$TIME_DAEMON_FILE

echo "Clear Cache..."
sudo kextcache -i /

echo "完成"

exit 0
