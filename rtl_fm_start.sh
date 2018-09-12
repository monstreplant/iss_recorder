#!/bin/bash

ROOTDIR="/root/scripts"
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG="$ROOTDIR/iss_recorder.log"

echo "Starting sampling on $TIMESTAMP" >> $LOG

PID=$(/bin/ps -ef | grep -w "rtl_tcp" | grep -v "grep" | awk '{print $2}')
if [ -n "$PID" ]; then
		kill -9 $PID
			echo "Service rtl_tcp has been stopped"
		fi

PID=$(/bin/ps -ef | grep -w "rtl_fm" | grep -v "grep" | awk '{print $2}')
if [ -n "$PID" ]; then
		echo "Recording is already running !" >> $LOG
		else
		echo "Starting recording." >> $LOG
		rtl_fm -f 145.800 | sox -r24k -e unsigned -b16 -c1 -traw - $ROOTDIR/samples/$TIMESTAMP.wav
		fi


