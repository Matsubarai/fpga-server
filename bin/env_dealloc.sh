#!/bin/bash
docker stop $USER-env
docker rm $USER-env
if [ -f "/usr/local/etc/timer_id.$USER" ]
then
	echo "deallocate env with devices..."
	atrm `cat /usr/local/etc/timer_id.$USER`
	echo -n "" > /usr/local/etc/timer_id.$USER
fi
