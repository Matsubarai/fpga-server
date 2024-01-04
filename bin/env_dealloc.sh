#!/bin/bash
docker stop $USER-env
docker rm $USER-env
if [ -f "/usr/local/etc/timer_id.$USER" ]
then
	atrm `cat  /usr/local/etc/timer_id.$USER`
	echo "" > /usr/local/etc/timer_id.$USER
fi
