#!/bin/bash
docker start $USER-env
docker exec -it -u $UID $USER-env /bin/bash
