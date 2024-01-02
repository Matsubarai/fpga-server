#!/bin/bash

cleanup () {
	kill -s SIGTERM $!
	if [ $PORT ];
	then
		echo $PORT >> /usr/local/etc/port_pool
	fi
	exit 0
}

trap cleanup SIGINT SIGTERM

if [ $JUPYTER_ENABLE = "true" ];
then
	jupyter lab 2>&1 &
	PID_SUB=$!
fi

if [ $VNC_ENABLE = "true" ];
then
	VNC_IP=$(hostname -i)
	$NO_VNC_HOME/utils/novnc_proxy --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT 2>&1 &
	PID_SUB=$!
	vncserver -kill $DISPLAY \
		|| rm -rfv /tmp/.X*-lock /tmp/.X11-unix \
		|| echo "no locks present"
	vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION -SecurityTypes None > /dev/null 2>&1
fi

if [ $1 ];
then
	$@ 2>&1 &
	PID_SUB=$!
fi

wait $PID_SUB

if [ $PORT ];
then
	echo $PORT >> /usr/local/etc/port_pool
fi
