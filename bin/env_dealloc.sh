#!/bin/bash
docker stop $USER-env
docker rm $USER-env
if [ -f "$HOME/.timer_id" ]
then
	atrm `cat $HOME/.timer_id`
	rm $HOME/.timer_id
fi
