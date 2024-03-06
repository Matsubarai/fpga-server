#!/bin/bash
docker start $USER-env
docker exec -it -u $UID -e DISPLAY=$DISPLAY $USER-env /bin/bash
