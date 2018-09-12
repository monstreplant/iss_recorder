#!/bin/bash

LOG="/iss_recorder/rtl_tcp_service.log"
BIN="/usr/bin/rtl_tcp"

start() {
PID=$(/bin/ps -ef | grep -w "rtl_tcp" | grep -v "grep" | awk '{print $2}')
if [ -z "$PID" ]; then
	$BIN -a 0.0.0.0&
else
	echo "Service is already up with PID $PID"
fi
}

stop() {
PID=$(/bin/ps -ef | grep -w "rtl_tcp" | grep -v "grep" | awk '{print $2}')
if [ -n "$PID" ]; then
	kill -9 $PID
	echo "Service has been stopped"
else
	echo "Service is already down"
fi
}

restart() {
stop
start
}

watch() {
while [ -z "$TRAP" ]; do
	start
	sleep 10
done
}

$1
