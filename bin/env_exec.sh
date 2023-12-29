#!/bin/bash
docker start $USER-env
docker exec -it $USER-env /bin/bash
