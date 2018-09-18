#!/bin/bash
ROOTDIR="/root/iss_recorder"
LOG="$ROOTDIR/iss_recorder.log"
#curl "http://api.open-notify.org/iss-pass.json?lat=43.598039&lon=6.986027&n=1"
if [ ! -f $ROOTDIR/iss_recorder.lock ]; then

	echo "Cleaning Jobs..." >> $LOG
	for id in $(atq | cut -f1); do atrm $id; done

	CURL=$(curl -s "http://api.open-notify.org/iss-pass.json?lat=43.598039&lon=6.986027&alt=150&n=1")

	UNIXTIME=$(echo $CURL | cut -d "," -f 8|cut -d " " -f 3)
	DURATION=$(echo $CURL | cut -d "," -f 7|cut -d " " -f 6)
	
	if [ "$DURATION" = "" ]; then
		echo "Setting duration to default value !" >> $LOG
		DURATION="600"
	fi

	STARTUTC=$(date -d @$UNIXTIME +%H:%M)
	START=$(date +%H:%M -d "$STARTUTC + 2 hours")
	STOP=$(date +%H:%M -d "$STARTUTC + 2 hours + $DURATION second")

	if [ -n "$START" ]; then

		echo "Programming next ISS Passage : Duration: $DURATION Start: $START Stop: $STOP" >> $LOG
		echo "Programming next ISS Passage : Duration: $DURATION Start: $START Stop: $STOP"

		at $START -f $ROOTDIR/rtl_fm_start.sh >> $LOG
		touch $ROOTDIR/iss_recorder.lock
		at $STOP -f $ROOTDIR/rtl_fm_stop.sh >> $LOG
	else
		echo "Error reading values from API !" >> $LOG
	fi

else
#	echo "Lockfile found, a record is already planned." >> $LOG
	
	echo -e "\nNext Recording :"
	atq

	echo -e "\nNext Pass :"
	for PASS in $(curl -s "http://api.open-notify.org/iss-pass.json?lat=43.598039&lon=6.986027&alt=150" | grep risetime | cut -d " " -f "8");do
		PASS_TIME_UTC=$(date -d @$PASS +%H:%M:%S)
		PASS_TIME=$(date -d "$PASS_TIME_UTC + 2 hours" +%H:%M:%S)
		echo $PASS_TIME
	done
fi
