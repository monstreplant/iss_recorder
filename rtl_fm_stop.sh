#!/bin/bash

ROOTDIR="/root/scripts"
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG="$ROOTDIR/iss_recorder.log"

echo "Stop sampling on $TIMESTAMP" >> $LOG

PID=$(/bin/ps -ef | grep -w "rtl_fm" | grep -v "grep" | awk '{print $2}')
if [ -n "$PID" ]; then
	kill -9 $PID
	echo "Stop recording." >> $LOG
	rm $ROOTDIR/iss_recorder.lock
	else
	echo "Not recording !" >> $LOG
fi
