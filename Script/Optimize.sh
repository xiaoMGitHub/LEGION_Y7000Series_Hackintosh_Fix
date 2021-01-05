#!/bin/bash

DAEMON_PATH=/Library/LaunchDaemons/
BIN_PATH=/usr/local/bin/
TMP_PATH=/tmp/
ALC_DAEMON_FILE=good.win.ALCPlugFix.plist
VERB_FILE=hda-verb
ALC_FIX_FILE=ALCPlugFix
TIME_FIX_FILE=localtime-toggle
TIME_DAEMON_FILE=org.osx86.localtime-toggle.plist
NUMLOCK_FIX_FILE=setleds
NUMLOCK_DAEMON_FILE=com.rajiteh.setleds.plist
GIT_URL=https://gitee.com/xiaoMGit/Y7000Series_Hackintosh_Fix/raw/master

init(){
	sudo spctl --master-disable
	sudo pmset -a hibernatemode 0
	sudo rm -rf /var/vm/sleepimage
	sudo mkdir /var/vm/sleepimage
	
	sudo curl -s -o $TMP_PATH$ALC_FIX_FILE "$GIT_URL/ALCPlugFix/$ALC_FIX_FILE"
	sudo curl -s -o $TMP_PATH$VERB_FILE "$GIT_URL/ALCPlugFix/$VERB_FILE"
	sudo curl -s -o $TMP_PATH$ALC_DAEMON_FILE "$GIT_URL/ALCPlugFix/$ALC_DAEMON_FILE"
	sudo curl -s -o $TMP_PATH$TIME_FIX_FILE "$GIT_URL/TimeSynchronization/$TIME_FIX_FILE"
	sudo curl -s -o $TMP_PATH$TIME_DAEMON_FILE "$GIT_URL/TimeSynchronization/$TIME_DAEMON_FILE"
	
	if [ ! -d "$BIN_PATH" ] ; then
		mkdir "$BIN_PATH" ;
	fi
	
	if sudo launchctl list | grep --quiet com.black-dragon74.ALCPlugFix; then
		sudo launchctl unload /Library/LaunchDaemons/com.black-dragon74.ALCPlugFix.plist
		sudo rm /Library/LaunchDaemons/com.black-dragon74.ALCPlugFix.plist
		sudo rm /usr/local/bin/ALCPlugFix
		sudo rm /Library/Preferences/ALCPlugFix/ALC_Config.plist
	fi
}

ALCPlugFix(){
	sudo cp $TMP_PATH$ALC_FIX_FILE $BIN_PATH
	sudo cp $TMP_PATH$VERB_FILE $BIN_PATH
	sudo cp $TMP_PATH$ALC_DAEMON_FILE $DAEMON_PATH
	sudo chmod 755 $BIN_PATH$ALC_FIX_FILE
	sudo chown $USER:admin $BIN_PATH$ALC_FIX_FILE
	sudo chmod 755 $BIN_PATH$VERB_FILE
	sudo chown $USER:admin $BIN_PATH$VERB_FILE
	sudo chmod 644 $DAEMON_PATH$ALC_DAEMON_FILE
	sudo chown root:wheel $DAEMON_PATH$ALC_DAEMON_FILE
	if sudo launchctl list | grep --quiet ALCPlugFix; then
		sudo launchctl unload $DAEMON_PATH$ALC_DAEMON_FILE
	fi
	sudo launchctl load -w $DAEMON_PATH$ALC_DAEMON_FILE
}

localtime-toggle(){
	sudo cp $TMP_PATH$TIME_FIX_FILE $BIN_PATH
	sudo cp $TMP_PATH$TIME_DAEMON_FILE $DAEMON_PATH
	sudo chmod +x $BIN_PATH$TIME_FIX_FILE
	sudo chown root $DAEMON_PATH$TIME_DAEMON_FILE
	sudo chmod 644 $DAEMON_PATH$TIME_DAEMON_FILE
	if sudo launchctl list | grep --quiet localtime-toggle; then
		sudo launchctl unload $DAEMON_PATH$TIME_DAEMON_FILE
	fi
	sudo launchctl load -w $DAEMON_PATH$TIME_DAEMON_FILE
}

numlock(){
	sudo cp $TMP_PATH$NUMLOCK_FIX_FILE $BIN_PATH
	sudo cp $TMP_PATH$NUMLOCK_DAEMON_FILE $DAEMON_PATH
	sudo chmod +x $BIN_PATH$NUMLOCK_FIX_FILE
	sudo chown root:wheel $DAEMON_PATH$NUMLOCK_DAEMON_FILE
	if sudo launchctl list | grep --quiet setleds; then
		sudo launchctl unload $DAEMON_PATH$NUMLOCK_DAEMON_FILE
	fi
	sudo launchctl load -w $DAEMON_PATH$NUMLOCK_DAEMON_FILE
}

clear_cache(){
	sudo kextcache -i /
	echo "done"
}

fixAll(){
	ALCPlugFix
	numlock
	localtime-toggle
}

menu(){
	echo "
************************************************************************************
                                                                                   
    https://github.com/xiaoMGitHub/LEGION_Y7000Series_Hackintosh/releases  
                                                                                  
************************************************************************************
"
    echo "选择菜单："
	echo ""
    echo "1、修复插耳机杂音"
	echo ""
    echo "2、修复数字键盘无法开启"
	echo ""
    echo "3、修复 Win/OSX 时间不同步"
	echo ""
	echo "4、全部修复上述问题"
	echo ""
	echo "5、退出"
	echo ""
}

Select(){
	read -p "请选择你需要执行的操作：" number
    case ${number} in
    1) ALCPlugFix
	   echo "已经修复插耳机杂音"
	   echo ""
	   Select
      ;;
    2) numlock
	   echo "已经修复数字键盘无法开启"
	   echo ""
	   Select
       ;;
    3) localtime-toggle
	   echo "已经修复 Win/OSX 时间不同步"
	   echo ""
	   Select
       ;;
	4) fixAll
	   echo "已经修复上述问题"
	   echo ""
	   Select
       ;;
	5) exit 0
       ;;
    *) echo "输入错误";
	   echo ""
       Select
       ;;
    esac
}

main(){
	init
	
	menu
	
	Select
	
	clear_cache
}

main

