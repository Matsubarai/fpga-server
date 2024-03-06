#!/bin/bash
XILINX_VERSION="2022.2"
EXC="true"
PUB="false"
REPO="ghcr.io/matsubarai/Vitis-Docker"
IMG="${REPO}/vitis:base"
while getopts ":d:i:v:m:psh" optname
do
	case "$optname" in
		"d")
			DEVICE=$OPTARG
			;;
		"s")
			EXC="false"
			;;
		"p")
			PUB="true"
			EXPOSE_PORT=8888
			;;
		"i")
			IMG="$REPO/$OPTARG"
			;;
		"v")
			XILINX_VERSION=$OPTARG
			;;
		"m")
			MNT="$MNT --volume $OPTARG" 
			;;
		"h")
			echo "USAGE: env_alloc [-d <DEVICE_ID[,...]=NULL>] [-s (NO_EXCLUSION_FLAG)] [-p (JUPYTER_ENABLE_FLAG)] [-v <TOOLCHAIN=2022.2>] [-i <ENV_IMAGE=vitis:base>]"
			exit 0
			;;
		":")
			echo "[ERROR] No argument value for option -$OPTARG"
			exit 1
			;;
		"?")
			echo "[ERROR] Unknown option $OPTARG"
			exit 1
			;;
		*)
			echo "[ERROR] Unknown error while processing options"
			exit 1
			;;
	esac
done
if [ $MNT ]
then
	echo "[INFO] custom mount point:$MNT"
fi

FLAGS="--detach --network host --name $USER-env --workdir /home/$USER --runtime=xilinx --env XILINX_VISIBLE_DEVICES=$DEVICE --env XILINX_DEVICE_EXCLUSIVE=$EXC --env XILINX_VERSION=${XILINX_VERSION} --env XILINXD_LICENSE_FILE=/tools/Xilinx --env QT_X11_NO_MITSHM=1 --env NO_AT_BRIDGE=1 --env LIBGL_ALWAYS_INDIRECT=1 --env HOST_USER=${USER} --env HOST_UID=$(id -u ${USER}) --env HOST_GROUP=${USER} --env HOST_GID=$(id -g ${USER}) --volume /etc/timezone:/etc/timezone --volume /etc/localtime:/etc/localtime --volume /tmp/.X11-unix:/tmp/.X11-unix:rw --volume /usr/local/MATLAB:/usr/local/MATLAB --volume /tools/Xilinx:/tools/Xilinx --volume /home/$USER:/home/$USER --volume /usr/local/etc:/usr/local/etc $MNT"

docker inspect $USER-env > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "[WARNING] Environment exists. You can deallocate it later."
	exec /usr/local/bin/env_exec
fi

if [ $PUB = "true" ]
then
	PORT=`head -n 1 /usr/local/etc/port_pool`
	cp /usr/local/etc/port_pool ./.port_pool.temp
	sed -i '1d' ./.port_pool.temp
	cat ./.port_pool.temp > /usr/local/etc/port_pool
	rm ./.port_pool.temp

	echo "[INFO] Jupyter IDE mode"
	if [ $PORT ]
	then
		echo "[INFO] Publish jupyter port $EXPOSE_PORT/tcp -> localhost:$PORT"
		docker run -p $PORT:$EXPOSE_PORT --env PORT=$PORT $FLAGS $IMG sleep infinity
	else
		echo "[WARNING] No valid port for publishing, use a random port"
		docker run -P $FLAGS $IMG sleep infinity
	fi
else
	echo "[INFO] Command-line mode"
	docker run $FLAGS $IMG sleep infinity
fi

sleep 1
if [ $? -ne 0 ]
then
	if [ $PORT ]
	then
		echo $PORT >> /usr/local/etc/port_pool
	fi
	exit 1
fi
if [ $DEVICE ]
then
	at -f /usr/local/bin/env_dealloc now +2 hours 2>&1 | grep -o '[0-9]\+' | head -1 > /usr/local/etc/timer_id.$USER
	echo "[INFO] Device[$DEVICE] will be released after 2 hours."
fi

echo "[INFO] !!! sudo password: $USER !!!"
exec /usr/local/bin/env_exec
